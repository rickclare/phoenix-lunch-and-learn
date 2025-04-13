import Config

logger_level = "LOGGER_LEVEL" |> System.get_env("debug") |> String.to_existing_atom()

# For development, we disable any cache and enable

# Do not include metadata nor timestamps in development logs
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we can use it
# to bundle .js and .css sources.
config :logger, :default_formatter, format: "[$level] $message\n"
config :logger, level: logger_level

# Configure your database
config :lunch, Lunch.Repo, database: "priv/db/development.db"

config :lunch, LunchWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  http: [ip: {0, 0, 0, 0}, port: "PORT" |> System.get_env("4000") |> String.to_integer()],
  url: [scheme: "https", host: System.get_env("PHX_HOST", "localhost")],
  https: [
    port: 4443,
    cipher_suite: :strong,
    certfile: "priv/cert/selfsigned.pem",
    keyfile: "priv/cert/selfsigned_key.pem"
  ],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "6FImzEYx73q3bKQbLvNFaO/8pmu1SaVoKOygnYhHveq0mHKREWp/Z6waPCvDcW8R",
  watchers: [
    bun: {Bun, :install_and_run, [:js, ~w(--sourcemap=external --watch)]},
    bun: {Bun, :install_and_run, [:css, ~w(--watch)]}
  ]

# Watch static and templates for browser reloading.
config :lunch, LunchWeb.Endpoint,
  live_reload: [
    web_console_logger: true,
    patterns: [
      ~r"priv/static/(?!uploads/).*(js|css|png|jpeg|jpg|gif|svg|webp)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/lunch_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

# Enable dev routes for dashboard and mailbox
config :lunch, dev_routes: true

# Initialize plugs at runtime for faster development compilation
# Set a higher stacktrace during development. Avoid configuring such
# Include HEEx debug annotations as HTML comments in rendered markup.
config :phoenix, :plug_init_mode, :runtime
# in production as building large stacktraces may be expensive.
# Changing this configuration will require mix clean and a full recompile.
config :phoenix, :stacktrace_depth, 20

config :phoenix_live_view,
  debug_heex_annotations: true,
  debug_attributes: true,
  # Enable helpful, but potentially expensive runtime checks
  enable_expensive_runtime_checks: true

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false
