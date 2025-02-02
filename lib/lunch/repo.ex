defmodule Lunch.Repo do
  use Ecto.Repo,
    otp_app: :lunch,
    adapter: Ecto.Adapters.SQLite3
end
