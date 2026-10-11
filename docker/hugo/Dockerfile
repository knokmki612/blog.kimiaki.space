FROM debian:bookworm-slim

ARG HUGO_VERSION=0.167.0

RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates curl \
 && curl -fsSL "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_linux-amd64.tar.gz" \
      -o /tmp/hugo.tar.gz \
 && tar -C /usr/local/bin -xzf /tmp/hugo.tar.gz hugo \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/hugo.tar.gz

WORKDIR /site

ENTRYPOINT ["hugo"]
