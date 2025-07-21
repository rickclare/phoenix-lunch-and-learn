ARG ELIXIR_VERSION=1.18.4
ARG OTP_VERSION=28.0.2
ARG DEBIAN_VERSION=bookworm-20250721-slim
ARG BUN_VERSION=1.2.19
ARG TARGETPLATFORM
ARG BUILDPLATFORM

FROM docker.io/hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}

# Copy these ARGs into the build stage
ARG BUN_VERSION
ARG TARGETPLATFORM
ARG BUILDPLATFORM

RUN apt-get update -qq \
  && apt-get install -yqq build-essential git brotli \
  locales libstdc++6 openssl libncurses6 \
  inotify-tools curl zip \
  && rm -rf /var/lib/apt/lists/*

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

RUN curl -fsSL https://bun.sh/install | bash -s "bun-v${BUN_VERSION}"

# NOTE: Setting ERL_AFLAGS increases compatibility when creating a linux/amd64 build
# when running the build on ARM processor (e.g. Apple MacOS Silicon)
# (see https://hexdocs.pm/mix/Mix.Tasks.Release.html#module-using-images)
ENV ERL_AFLAGS="+JMsingle true"

RUN mix do local.hex --force, local.rebar --force

WORKDIR /app

COPY mix.exs mix.lock ./
RUN mix deps.get

COPY config config
RUN mix deps.compile

COPY bun.lock package.json ./
COPY assets/package.json assets/
RUN mkdir -p _build && cp /root/.bun/bin/bun _build/
RUN _build/bun install

COPY priv priv
COPY assets assets
COPY lib lib

RUN mix compile
RUN mix ecto.setup
RUN mix assets.build

CMD ["mix", "phx.server"]
