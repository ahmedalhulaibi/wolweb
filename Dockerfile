#syntax=docker/dockerfile:1.2
FROM golang:1.17 AS builder

RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

# Force fetching modules over SSH
RUN git config --system url."ssh://git@github.com/".insteadOf "https://github.com/"

WORKDIR /go/src/github.com/sameerdhoot/wolweb

COPY . .

RUN --mount=type=ssh \
    --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    go mod tidy

RUN --mount=type=ssh \
    --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    CGO_ENABLED=0 \
    GOOS=linux \
    go build -o app .

FROM alpine:3.15.0 AS final

ARG WOLWEBPORT ":8089"

WORKDIR /

COPY --from=builder /go/src/github.com/sameerdhoot/wolweb/app app
COPY --from=builder /go/src/github.com/sameerdhoot/wolweb/index.html .
COPY --from=builder /go/src/github.com/sameerdhoot/wolweb/devices.json .
COPY --from=builder /go/src/github.com/sameerdhoot/wolweb/config.json .
COPY --from=builder /go/src/github.com/sameerdhoot/wolweb/static ./static

CMD ["/app"]
