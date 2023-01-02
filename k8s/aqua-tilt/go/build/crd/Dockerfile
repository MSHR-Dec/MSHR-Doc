## builder
FROM golang:1.18.7-alpine3.16 as builder

WORKDIR /crd
COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main ./cmd/crd

## runner
FROM alpine:3.16

COPY --from=builder /crd/main /crd/main

RUN adduser -u 1000 -s /sbin/nologin -D go && \
    chown go /crd/main && \
    chmod +x /crd/main
USER go

CMD ["/crd/main"]
