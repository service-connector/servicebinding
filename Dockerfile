FROM golang:bullseye as builder

RUN apt-get update -y
RUN apt-get install -y unzip

RUN set -eux; \
    wget -O /tmp/runtime.zip "https://github.com/servicebinding/runtime/archive/refs/heads/main.zip"; \
    cd /tmp && unzip runtime.zip; \
    cd /tmp/runtime-main && go build .

FROM debian:bullseye-slim
WORKDIR /
COPY --from=builder /tmp/runtime-main/runtime .
USER nobody
ENTRYPOINT ["/runtime"]
