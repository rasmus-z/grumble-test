FROM golang:1.9-alpine as builder

COPY . /go/src/mumble.info/grumble

WORKDIR /go/src/mumble.info/grumble

RUN apk add --no-cache git \
  && go get -v -t ./... \
  && go build github.com/rasmus-z/grumble/cmd/grumble \
  && go test -v ./...

FROM alpine:edge

COPY --from=builder /go/bin/grumble /usr/bin/grumble

ENV DATADIR /data

RUN mkdir /data

WORKDIR /data

VOLUME /data

ENTRYPOINT [ "/usr/bin/grumble", "--datadir", "/data", "--log", "/data/grumble.log" ]
