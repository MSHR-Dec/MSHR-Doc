# ローカルLLM (Gemma3 4B) on Ubuntu Server 26.04 (ASUS NUC 14 Pro / Core Ultra 5 125H)

Docker + llama.cpp Vulkan バックエンドで構築する。

> 当初は gpt-oss-20b (MoE) を想定していたが、実機検証の結果このハードウェアでは MoE アーキテクチャの生成速度が実用に耐えないことが判明し、dense モデルの ~~Gemma3 4B~~ **Qwen2.5-Coder-7B** に変更した。経緯は「モデル選定の経緯」を参照。

## 前提

- ASUS NUC 14 Pro (`RNUC14RVSU500000I`) / Core Ultra 5 125H (Meteor Lake, Xe-LPG iGPU)
- DDR5 16GB × 2 = 32GB(**デュアルチャネル**)
- Ubuntu Server 26.04 LTS
- 自宅 LAN 内からの利用。インターネットには公開しない

## 方式選定の理由

- **IPEX-LLM は使えない**。2026-01-28 を最後に更新が止まり、リポジトリはアーカイブ(読み取り専用)化された([GitHub](https://github.com/intel/ipex-llm))。
- Ollama 本体の Intel GPU (SYCL) 対応は v0.17 で入ったが iGPU での信頼性は低い。
- **llama.cpp の Vulkan バックエンド**が実用解。oneAPI/Level-Zero のような重量級スタックが不要で、公式コンテナイメージがあるので Docker が合理的(SYCLも公式イメージがあるが、後述の通り検証してもVulkanを上回らなかった)。

Ubuntu 26.04 LTS はカーネル 7.0 / Mesa 26.0.3 を標準搭載しており、Meteor Lake の i915/Xe サポートは完全にメインライン化済み。DKMS 等は不要。

### モデル選定の経緯(2026-08-22 実機検証)

当初 gpt-oss-20b(MoE, 21B total / 3.6B active, MXFP4ネイティブ量子化)を採用予定だった。DDR5-5600 デュアルチャネルの理論帯域 89.6 GB/s から見た見積もりでは生成速度 25〜30 tok/s を見込んでいたが、実機ベンチマークでは以下の通り大きく下回った。

| 構成 | tg128 (tok/s) | 備考 |
| --- | ---: | --- |
| gpt-oss 20B MoE (Vulkan) | 3.88〜8.47 | 実行のたびにばらつき、理論値の1/4以下 |
| Gemma3 12B dense (Vulkan, Q4_K_M) | 5.35 | denseでも改善せず |
| Gemma3 12B dense (Vulkan, Q4_0) | 5.07 | 量子化フォーマットは無関係と判明 |
| Gemma3 12B dense (Vulkan, `-fa 0`) | 4.79 | Flash Attentionも無関係(`-fa on`の方がわずかに良い) |
| Gemma3 12B dense (Vulkan, `GGML_VK_DISABLE_COOPMAT=1`) | 変化なし | coopmatも無関係 |
| Gemma3 12B dense (CPUのみ, `-ngl 0`) | pp512が50(GPU版の半分以下) | GPU offloadの方がまだ優位 |
| Gemma3 12B dense (SYCLバックエンド) | 7.09 | Vulkan比+32%程度だが実用域に届かず、pp512はVulkanより悪化 |
| **Gemma3 4B dense (Vulkan, Q4_K_M)** | 12.76 | **唯一実用速度に到達。**~~採用~~ |
| **Qwen2.5-Coder-7B (Vulkan, Q4_K_M)** | **10.26** | **採用** |

**分かったこと**:

- `pp512`(プロンプトの一括処理)は100〜270 tok/sと常に良好。遅いのは`tg128`(1トークンずつの逐次生成)だけ。
- gpt-oss(MoE)が特に遅いのは、MoEのエキスパート選択計算(`mul_mat_id`)がVulkanバックエンドでまだ十分最適化されておらず、特に行列演算専用コア(`matrix cores`)を持たないIntel iGPUで顕著に遅くなるため([Issue #18940](https://github.com/ggml-org/llama.cpp/issues/18940)、[Issue #18808](https://github.com/ggml-org/llama.cpp/issues/18808)、[Discussion #19674](https://github.com/ggml-org/llama.cpp/discussions/19674))。
- ただしdenseモデル(Gemma3 12B)でも理論値の半分以下しか出ず、量子化・Flash Attention・coopmat・GPUクロック(実測1746/2200MHz、RC6 0%でスリープなし)のいずれも原因ではなかった。Intel iGPU + Vulkanの`mul_mat_vec`(decode用の行列ベクトル積)自体が全般的に非効率という、より広範なエコシステムの制約による([Issue #17628](https://github.com/ggml-org/llama.cpp/issues/17628)、[Discussion #12570](https://github.com/ggml-org/llama.cpp/discussions/12570))。
- SYCLバックエンドは`.devops/intel.Dockerfile`からの自前ビルドが必要と思われがちだが、実際は`ghcr.io/ggml-org/llama.cpp`に`*-intel-bXXXXX`タグとしてVulkan版と同じビルド番号でビルド済みイメージが公開されている。ただし検証した限りVulkanを明確に上回らなかったため不採用。
- 結論として、**このハードウェアではモデルサイズが唯一の実効レバー**であり、4B級のdenseモデルまで落とすことで初めて実用的な生成速度(12〜13 tok/s、人が読む速度と同程度)に到達した。

16GB×2 のデュアルチャネル構成が前提。もし将来 1 枚挿しに変更すると帯域が半減し、生成速度もほぼ半分になる。念のための確認コマンド:

```bash
sudo dmidecode -t memory | grep -E 'Size|Locator|Configured Memory Speed'
```

`Size: 16 GB` が 2 行出ていれば想定通り。

---

## 0. カーネルと DRM ドライバの確認

```bash
uname -r                      # 7.0.x 系
lspci -nnk | grep -A3 -i vga  # Kernel driver in use: i915 または xe
```

Meteor Lake は i915 / xe どちらで拾われても Vulkan (ANV) からは同じように使える。トラブル時の切り分け用に控えておく。

## 1. ホスト側: Vulkan の疎通確認

```bash
sudo apt update
sudo apt install -y mesa-vulkan-drivers libvulkan1 vulkan-tools intel-gpu-tools
vulkaninfo --summary | grep -A5 'GPU0'
```

Intel iGPU (`Intel(R) Graphics (MTL)` 等) が出ることを確認する。ここで出ないと以降すべて動かない。

> **注意**: これは**切り分け用のスモークテストであって、必須の依存ではない**。llama.cpp の Vulkan イメージは base が `ubuntu:26.04` で `mesa-vulkan-drivers` を自前で同梱しているため、コンテナが実際に使う Vulkan ドライバはイメージ内のものになる。ホストと共有されるのはカーネルの DRM ドライバ (`/dev/dri`) だけ。
> したがって「コンテナ内で GPU を認識しない」場合に**ホストの Mesa を更新しても解決しない**。切り分けの方向を間違えないこと。

`intel-gpu-tools` は後で `intel_gpu_top` による GPU 実利用の確認に使う。

## 2. Docker のインストール

```bash
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker "$USER"
docker run --rm hello-world
```

26.04 (`resolute`) のリポジトリがまだ用意されていない場合は、Ubuntu 標準の `docker.io` で代替できる:

```bash
sudo apt install -y docker.io
sudo systemctl enable --now docker
```

> `render` グループへのホストユーザ追加は**不要**。後述の `--group-add` でコンテナ側に GID を渡すため。
> (`newgrp docker` は docker グループにしか効かないので、そもそも render の追加には使えない)

## 3. デバイスの確認

```bash
ls -l /dev/dri
getent group render
```

`renderD128` が存在し、`render` グループの GID が取得できることを確認する。

## 4. イメージの取得(タグは固定する)

Vulkan + Intel iGPU にはクラッシュ報告の履歴があるため、`latest` 相当のローリングタグではなく**ビルド番号付きタグを固定**する。

```bash
LLAMA_BUILD=b10573                       # 2026-08-22 時点の最新。更新時はここだけ変える
LLAMA_TAG=server-vulkan-${LLAMA_BUILD}   # サーバ常駐用(llama-server のみ同梱)
docker pull "ghcr.io/ggml-org/llama.cpp:${LLAMA_TAG}"
```

> **イメージには 3 種類ある**: `server`(`llama-server` のみ)/ `light`(`llama-cli` のみ)/ `full`(全バイナリ)。`server-vulkan` イメージには `llama-cli` も `llama-bench` も**入っていない**。CLI で使う場合(6章のモデル取得、10章の速度計測)は `light-vulkan-${LLAMA_BUILD}` または `full-vulkan-${LLAMA_BUILD}` タグを使うこと。ここを間違えると `stat /app/llama-cli: no such file or directory` のようなエラーになる。

利用可能なタグの一覧:

```bash
TOK=$(curl -s "https://ghcr.io/token?scope=repository%3Aggml-org%2Fllama.cpp%3Apull&service=ghcr.io" \
      | sed -n 's/.*"token":"\([^"]*\)".*/\1/p')
curl -s -H "Authorization: Bearer $TOK" \
  "https://ghcr.io/v2/ggml-org/llama.cpp/tags/list?n=1000" \
  | tr ',' '\n' | grep -o 'server-vulkan-b[0-9]*' | sort -t b -k2 -n | tail
```

> このAPIは1ページ1000件で打ち切られる。`&last=<最後のタグ名>` を付けて追いページを取得しないと最新タグを見落とす(`server-vulkan`は3000件近くある)。

> **既知クラッシュについて**: [#20201](https://github.com/ggml-org/llama.cpp/issues/20201)(Intel iGPU + Vulkan、b8148 以降でクラッシュ)は 2026-04-23 に close 済み。b8363 / Mesa 26.0.2 以降で解消し、b8901 でも安定との報告がある。[#19327](https://github.com/ggml-org/llama.cpp/issues/19327) は **Arrow Lake** の事例で Meteor Lake とは別。
> したがって不安定な場合の対処は「古いタグに戻す」ではなく「**より新しいビルドに上げる**」。上記の b8363 より古いビルドは避ける。

## 5. コンテナから GPU が見えるか確認

```bash
docker run --rm --device /dev/dri \
  --group-add "$(getent group render | cut -d: -f3)" \
  "ghcr.io/ggml-org/llama.cpp:${LLAMA_TAG}" --list-devices
```

`Intel(R) Graphics (MTL)` のように iGPU が列挙されれば OK。`uma: 1` が出ていれば統合メモリとして認識されている。

## 6. モデルの取得

先にダウンロードしてから起動する(`-d` で起動すると DL 中なのか起動失敗なのか判別できないため)。

```bash
mkdir -p ~/llama-models/
docker run --rm -t \
  -v ~/llama-models:/root/.cache/huggingface \
  --entrypoint /app/llama-cli \
  "ghcr.io/ggml-org/llama.cpp:light-vulkan-${LLAMA_BUILD}" \
  -hf unsloth/gemma-3-4b-it-GGUF:Q4_K_M --no-warmup -n 0 --verbose
find ~/llama-models -name '*.gguf'
```

> **マウント先は `/root/.cache/huggingface`**(`/root/.cache/llama.cpp` ではない)。llama.cpp の `-hf` ダウンローダは Hugging Face 標準のキャッシュレイアウト(`hub/models--<org>--<repo>/blobs/…` + `snapshots/<commit>/<filename>` のシンボリックリンク)を使う。マウント先を間違えるとダウンロードはコンテナの一時領域に書き込まれ、`--rm` で消える(進捗バーは進むのでダウンロード自体は成功しているように見えて気づきにくい)。

取得されるのは `gemma-3-4b-it-Q4_K_M.gguf` (約2.3GB、実体は `~/llama-models/hub/models--unsloth--gemma-3-4b-it-GGUF/blobs/` 以下、`snapshots/` 以下にファイル名でのシンボリックリンクがある)。このリポジトリは複数の量子化フォーマットを含むので、`:Q4_K_M` のようにタグで明示指定すること(省略すると別のファイルが降ってくる)。

> コンテナは root で動くのでファイルは root 所有になる。気になる場合は `--user "$(id -u):$(id -g)"` を付けて実行する(その場合 `--group-add` も併用が必要)。

## 7. サーバ起動

```bash
docker run -d --name gemma3-4b \
  --restart unless-stopped \
  --device /dev/dri \
  --group-add "$(getent group render | cut -d: -f3)" \
  -v ~/llama-models:/root/.cache/huggingface \
  -p 8080:8080 \
  "ghcr.io/ggml-org/llama.cpp:${LLAMA_TAG}" \
  -hf unsloth/gemma-3-4b-it-GGUF:Q4_K_M \
  --jinja \
  -ngl 999 -fa on --no-mmap \
  -c 32768 -b 2048 -ub 2048 \
  --temp 1.0 --top-k 64 --top-p 0.95 --min-p 0.0 \
  --no-warmup
```

LAN の他ホストから叩けるよう `-p 8080:8080`(全インタフェース)で公開する。認証は付けていないので、**自宅 LAN 内に閉じていること**が前提。ルータのポートフォワードを開けないこと。

### オプションの意図

| オプション | 理由 |
| --- | --- |
| `--jinja` | モデル内蔵のchat templateを正しく適用するために有効化(system role・tool callの扱いが安定する) |
| `-ngl 999` | 全レイヤーを iGPU にオフロード |
| `-fa on` | Flash Attention。実測でも`-fa off`よりわずかに速い |
| `--no-mmap` | mmap 由来の二重常駐を避ける |
| `-b 2048 -ub 2048` | プロンプト処理のスループット。確保に失敗する場合は 1024 → 512 と下げる |
| `--temp 1.0 --top-k 64 --top-p 0.95 --min-p 0.0` | Gemmaチームの公式推奨サンプリング値([HF Discussion](https://huggingface.co/google/gemma-3-12b-it/discussions/25)) |
| `--host 0.0.0.0` | **不要**。イメージが `LLAMA_ARG_HOST` で既に設定済み |

### コンテキスト長について

Gemma3 4Bは128Kコンテキストに対応しているが、4B級モデルはKVキャッシュも小さく32GB RAMでは余裕があるため、gpt-oss-20bの時のような精密なバイト計算は不要と判断した。`-c 32768`をデフォルトにしているが、長い会話履歴が必要なら`-c 0`(フル128K)に上げても問題ない。実際のメモリ使用量は`docker logs`の起動ログや`free -h`で確認すること。

## 8. 動作確認

```bash
docker logs -f gemma3-4b   # "server is listening" まで待つ
curl -s http://localhost:8080/health
```

```bash
curl -s http://localhost:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{"messages":[{"role":"user","content":"自己紹介して"}]}' | jq .
```

**確認すべき点**: `choices[0].message.content` に `<start_of_turn>` 等の特殊トークンが**混入していない**こと → 混入していたら `--jinja` が効いていない。

LAN 内の別ホストからも `http://<NUC の IP>:8080/v1/chat/completions` で疎通することを確認する。

### GPU が実際に使われているか

```bash
sudo intel_gpu_top
```

推論中に Render/3D の使用率が上がることを確認する。上がらない場合は CPU にフォールバックしている。`docker logs` の起動時ログで `ggml_vulkan: 0 = Intel(R) Arc(tm) Graphics (MTL)` と、全レイヤーが GPU に割り当てられている行を確認する。

### 速度計測

`docker logs` の `eval time` に tokens per second が出る。再現可能な数値が欲しい場合は `llama-bench`(`full-vulkan` イメージに同梱):

```bash
docker run --rm --device /dev/dri \
  --group-add "$(getent group render | cut -d: -f3)" \
  -v ~/llama-models:/root/.cache/huggingface \
  --entrypoint /app/llama-bench \
  "ghcr.io/ggml-org/llama.cpp:full-vulkan-${LLAMA_BUILD}" \
  -hf unsloth/gemma-3-4b-it-GGUF:Q4_K_M -ngl 999 -fa 1
```

`tg128`(生成)が**12〜13 tok/s**前後なら実機検証時と同等。大きく下回る場合はGPUオフロードが効いていないか、メモリがシングルチャネル動作になっている可能性を疑う(「モデル選定の経緯」の表を参照。このハードウェアではこれ以上の速度は望みにくい)。

なお NUC 14 Pro は筐体が小さく、長時間の連続推論でサーマルスロットリングが起きうる。`sensors` / `intel_gpu_top` で継続的に監視すること(実測ではRender/3D 99%稼働・RC6 0%・クロック1746/2200MHzで、クロック引き上げの余地は最大でも2〜3割程度と見積もっている)。

## 9. 常駐化 (docker compose)

`~/llama/compose.yaml`:

```yaml
services:
  qwen2.5-coder-7b:
    image: ghcr.io/ggml-org/llama.cpp:server-vulkan-b10573
    container_name: qwen2.5-coder-7b
    restart: unless-stopped
    devices:
      - /dev/dri:/dev/dri
    group_add:
      - "${RENDER_GID}"
    volumes:
      - ~/llama-models:/root/.cache/huggingface
    ports:
      - "8080:8080"
    # 文字列で書くと Compose の shlex 分割で JSON の引用符が剥がれるため、必ずリスト形式にする
    command:
      - -hf
      - unsloth/Qwen2.5-Coder-7B-Instruct-GGUF:Q4_K_M
      - --jinja
      - -ngl
      - "999"
      - -fa
      - "on"
      - --no-mmap
      - -c
      - "0"
      - -b
      - "2048"
      - -ub
      - "2048"
      - --temp
      - "0.7"
      - --top-p
      - "0.8"
      - --repeat-penalty
      - "1.05"
```

`~/llama/.env`:

```bash
RENDER_GID=993   # getent group render | cut -d: -f3 の値に置き換える
```

```bash
cd ~/llama && docker compose up -d
docker compose logs -f
```

イメージ側に `/health` を叩く HEALTHCHECK が入っているので、`docker ps` の STATUS が `healthy` になることを確認する。

### アップグレード手順

```bash
cd ~/llama
# compose.yaml の image タグを新しいビルド番号に書き換えてから
docker compose pull && docker compose up -d
```

タグを固定しているので `pull` だけでは更新されない。問題が出たら前のタグに戻すだけでロールバックできる。

---

## 不安定な場合の切り分け順序

1. **ビルドを上げる** — 古いビルド起因のクラッシュが大半。b8363 以降であることを確認
2. `-b` / `-ub` を 1024 → 512 に下げる — iGPU は共有メモリの確保上限が先に効く
3. `-c` を下げる
4. `-ngl 0`(全 CPU)で動くか確認 — 動けば GPU 経路の問題、動かなければモデル/テンプレート側の問題(ただし実測ではCPUの方が`pp512`で明確に遅かったので、速度改善目的では推奨しない)
5. SYCLバックエンドを試す — `ghcr.io/ggml-org/llama.cpp:full-intel-${LLAMA_BUILD}` のようにビルド済みイメージが公開されており、自前ビルドは**不要**。ただし実測では`tg128`がVulkan比+32%程度に留まり、`pp512`はVulkanより悪化した。安定性の問題を切り分けたい場合のみ試す価値がある
6. 生成速度そのものが遅い場合、上記4・5では大きく改善しない。**モデルサイズを落とす**のが唯一有効だった対策(「モデル選定の経緯」参照)

---

## Sources

- [IPEX-LLM archived — GitHub](https://github.com/intel/ipex-llm)
- [llama.cpp Docker docs](https://github.com/ggml-org/llama.cpp/blob/master/docs/docker.md)
- [llama.cpp server README](https://github.com/ggml-org/llama.cpp/blob/master/tools/server/README.md)
- [Intel iGPU + Vulkan crash (closed) — issue #20201](https://github.com/ggml-org/llama.cpp/issues/20201)
- [Arrow Lake iGPU Vulkan crash (closed) — issue #19327](https://github.com/ggml-org/llama.cpp/issues/19327)
- [Ubuntu 26.04 LTS ships Linux 7.0 — Ubuntu Discourse](https://discourse.ubuntu.com/t/26-04-lts-resolute-raccoon-shipping-with-the-final-7-0-linux-kernel/80838)
- [mesa-vulkan-drivers (resolute 26.04) — UbuntuUpdates](https://www.ubuntuupdates.org/package/core/resolute/main/base/mesa-vulkan-drivers)
- [Misc. bug: GPT-OSS 120b prompt processing extremely low on intel dGPU — issue #18940](https://github.com/ggml-org/llama.cpp/issues/18940)
- [Misc. bug: Totally broken for agentic use on Intel dGPUs — issue #18808](https://github.com/ggml-org/llama.cpp/issues/18808)
- [Help with optimising GPT-OSS-120B on the Vulkan branch — discussion #19674](https://github.com/ggml-org/llama.cpp/discussions/19674)
- [Misc. bug: Vulkan's performance degradation(TG) on A770 from b7194 and FA problem — issue #17628](https://github.com/ggml-org/llama.cpp/issues/17628)
- [Current status of Intel Arc GPUs for llama.cpp — discussion #12570](https://github.com/ggml-org/llama.cpp/discussions/12570)
- [unsloth/gemma-3-4b-it-GGUF — Hugging Face](https://huggingface.co/unsloth/gemma-3-4b-it-GGUF)
- [unsloth/gemma-3-12b-it-GGUF — Hugging Face](https://huggingface.co/unsloth/gemma-3-12b-it-GGUF)
- [google/gemma-3-12b-it recommended inference settings — HF Discussion](https://huggingface.co/google/gemma-3-12b-it/discussions/25)
