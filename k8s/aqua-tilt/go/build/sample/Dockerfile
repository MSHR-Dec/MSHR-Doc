## builder
FROM golang:1.18.7-alpine3.16 as builder

WORKDIR /sample
COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main ./cmd/sample

## runner
FROM alpine:3.16

COPY --from=builder /sample/main /sample/main

RUN adduser -u 1000 -s /sbin/nologin -D go && \
    chown go /sample/main && \
    chmod +x /sample/main
USER go

ENTRYPOINT ["/sample/main"]
