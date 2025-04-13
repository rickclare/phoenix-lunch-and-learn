import IEx.Helpers

alias Lunch.Accounts
alias Lunch.Accounts.User
alias Lunch.Accounts.UserToken
alias Lunch.Repo

IEx.configure(
  auto_reload: true,
  default_prompt: "%prefix:%counter>",
  alive_prompt: "%prefix(%node):%counter>",
  history_size: -1,
  colors: [
    eval_result: [:yellow, :bright]
  ]
)

import_if_available(Ecto.Query)
