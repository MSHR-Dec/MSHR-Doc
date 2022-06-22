## builder
FROM golang:1.17.5-alpine3.15 as migration-builder

WORKDIR /build
COPY . .
RUN cd go_task && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /build/main ./cmd/migration

## process
FROM alpine:3.15

COPY go_task/build/migration /
COPY --from=migration-builder /build/main /main
RUN apk update && \
    apk add mysql-client

CMD ["/start.sh"]
