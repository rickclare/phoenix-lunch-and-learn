# syntax=docker/dockerfile:1.7-labs

ARG ELIXIR_VERSION=1.18.2
ARG OTP_VERSION=27.2.1
ARG DEBIAN_VERSION=bookworm-20250113-slim

ARG BUILDER_IMAGE="docker.io/hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"

FROM ${BUILDER_IMAGE}

# Increase compatibility for Apple Silicon MacOS builds
ENV ERL_AFLAGS="+JMsingle true"

# install build dependencies
RUN apt-get update -qq \
  && apt-get install -yqq build-essential git brotli \
  locales libstdc++6 openssl libncurses6 \
  inotify-tools curl zip \
  && rm -rf /var/lib/apt/lists/*

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

RUN curl -fsSL https://bun.sh/install | bash

RUN mix local.hex --force \
  && mix local.rebar --force

WORKDIR /app

# install mix dependencies
COPY --parents mix.exs mix.lock local_deps/ ./
RUN mix deps.get

# copy compile-time config files before we compile dependencies
# to ensure any relevant config change will trigger the dependencies to be re-compiled.
COPY config config
RUN mix deps.compile

COPY bun.lock package.json ./
COPY assets/package.json assets/
RUN mkdir -p _build && cp /root/.bun/bin/bun _build/
RUN _build/bun install

COPY --parents assets/ priv/ lib/ ./

RUN mix compile
RUN mix ecto.setup
RUN mix assets.build

CMD ["mix", "phx.server"]
