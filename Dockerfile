FROM golang:alpine as build-env

#RUN mkdir -p /home/go/
#COPY . /home/go
#RUN mkdir -p /home/go/
#RUN adduser -D -g '' go

ENV GO111MODULE=on
ENV CGO_ENABLED=0
#ENV GOOS=linux
#ENV GOARCH=amd64

WORKDIR /go/src/github.com/

COPY go.mod .
COPY go.sum .

RUN apk update && apk add ca-certificates && apk add git

COPY . .

RUN go build -ldflags="-w -s" -o app .
################################################################################

FROM scratch
COPY --from=build-env /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build-env /go/src/github.com/app /go/bin/app

 

ENTRYPOINT ["/go/bin/app"]
