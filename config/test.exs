import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Print only warnings and errors during test
config :logger, level: :warning

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used

# In test we don't send emails
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :lunch, Lunch.Mailer, adapter: Swoosh.Adapters.Test
config :lunch, Lunch.Repo, database: "priv/db/test.db", pool: Ecto.Adapters.SQL.Sandbox

config :lunch, LunchWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "BoHfeLqZOZnGXx2N74yFOx3AkJ63Guu9PLxAFGGt79vWBA11iO7Oryym4HHNpbcq",
  server: false

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false
