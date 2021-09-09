defmodule Film.Repo do
  use Ecto.Repo,
    otp_app: :exercise2,
    adapter: Ecto.Adapters.Postgres
    use Scrivener, page_size: 20
end
