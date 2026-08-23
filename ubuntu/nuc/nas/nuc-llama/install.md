パスワードなしで NAS にアクセスするためには、Samba 設定を少し変更します。以下に具体的な手順を示します。

### 1. Samba のインストール

既にインストールされている場合は、スキップします。まだインストールしていない場合は、以下のコマンドでインストールします。

```sh
sudo apt update
sudo apt install samba
```

### 2. 共有ディレクトリの作成

共有ディレクトリを作成します。

```sh
sudo mkdir -p /srv/samba/nas
sudo chown -R nobody:nogroup /srv/samba/nas
sudo chmod -R 755 /srv/samba/nas
```

### 3. Samba 設定の編集

Samba の設定ファイルを編集します。

```sh
sudo nano /etc/samba/smb.conf
```

ファイルの末尾に以下のようなセクションを追加します。

```ini
[nas]
   comment = NAS Share
   path = /srv/samba/nas
   browseable = yes
   read only = no
   writable = yes
   guest ok = yes
   create mask = 0755
```

### 4. Samba サービスの再起動

Samba サービスを再起動します。

```sh
sudo systemctl restart smbd
sudo systemctl restart nmbd
```

### 5. ファイアウォール設定

ファイアウォール設定を更新して Samba ポートを開放します。

```sh
sudo ufw allow samba
```

### 6. Mac からアクセス

Mac 上で NAS にアクセスするには、Finder を開き、「Go」メニューから「Connect to Server...」を選択します。次に、以下のように URL を入力します。

```
smb://ubuntu/nas
```

ユーザー名とパスワードを空欄で接続します。

### 7. スマホからアクセス

スマホ上では、ファイル共有アプリケーションを使用して NAS にアクセスできます。Samba 共有は多くのアプリケーションでサポートされています。

### 注意事項

- **セキュリティ**: パスワードなしで共有を行う場合は、LAN 内からのアクセス制限や物理的なセキュリティ対策を実施してください。
- **バックアップ**: 定期的なバックアップを行うことをお勧めします。
- **アップデート**: 操作システムと Samba を定期的に更新してください。

以上でパスワードなしで NAS にアクセスできるようになりました。自宅 LAN 内からのアクセスは制限されており、セキュリティ対策を考慮して使用してください。
