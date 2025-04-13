# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# Configure bun (the version is required)
config :bun,
  version: "1.2.9",
  js: [
    args: ~w(
      build js/app.js
        --outdir=../priv/static/assets
        --sourcemap=external
        --external /fonts/*
        --external /images/*
    ),
    cd: Path.expand("../assets", __DIR__),
    env: %{}
  ],
  css: [
    args: ~w(
      --bun tailwindcss
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__),
    env: %{}
  ]

# Configures Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :lunch, Lunch.Mailer, adapter: Swoosh.Adapters.Local

# Configures the endpoint
config :lunch, LunchWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: LunchWeb.ErrorHTML, json: LunchWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Lunch.PubSub,
  live_view: [signing_salt: "i8pDFt92"]

config :lunch,
  ecto_repos: [Lunch.Repo],
  generators: [timestamp_type: :utc_datetime]

# Import environment specific config. This must remain at the bottom

# Use Jason for JSON parsing in Phoenix
# of this file so it overrides the configuration defined above.
config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"
