## builder
FROM golang:1.18.7-alpine3.16 as builder

WORKDIR /job
COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main ./cmd/job

## runner
FROM alpine:3.16

COPY --from=builder /job/main /job/main

RUN adduser -u 1000 -s /sbin/nologin -D go && \
    chown go /job/main && \
    chmod +x /job/main
USER go

ENTRYPOINT ["/job/main"]
