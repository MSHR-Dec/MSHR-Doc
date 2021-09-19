FROM golang:1.16.3-alpine3.13 as build

WORKDIR /crd
COPY ../.. .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o myfirstcontroller ./code_generator

FROM alpine

WORKDIR /crd
COPY --from=build /crd/myfirstcontroller /crd/myfirstcontroller

CMD ["/crd/myfirstcontroller"]
