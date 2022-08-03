FROM golang:bullseye as builder
ARG upstream_tag

RUN apt-get update -y
RUN apt-get install -y unzip

RUN set -eux; \
    wget -O /tmp/runtime.tar.gz "https://github.com/servicebinding/runtime/archive/refs/tags/${upstream_tag}.tar.gz"; \
    mkdir -p /tmp/runtime && tar zxvf /tmp/runtime.tar.gz -C /tmp/runtime --strip-components=1; \
    cd /tmp/runtime && go build .

FROM debian:bullseye-slim
WORKDIR /
COPY --from=builder /tmp/runtime/runtime .
USER nobody
ENTRYPOINT ["/runtime"]
