# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Lunch.Repo.insert!(%Lunch.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Lunch.Accounts
alias Lunch.Repo

# Speed up user creation, by reducing password encryption complexity
Application.put_env(:bcrypt_elixir, :log_rounds, 4)

default_password = "Password123!"

Enum.each(
  [
    %{name: "John Smith", email: "john@example.com"},
    %{name: "Jane Jones", email: "jane@example.org"},
    %{name: "Zaphod Beeblebrox", email: "zaphod@example.org"}
  ],
  fn %{email: email} = attrs ->
    if !Accounts.get_user_by_email(email) do
      Repo.transaction(fn ->
        %Accounts.User{}
        |> Accounts.change_user(attrs)
        |> Repo.insert!()
        |> Accounts.change_user_password(%{password: default_password})
        |> Repo.update!()
      end)
    end
  end
)
