defmodule Film.Repo do
  use Ecto.Repo,
    otp_app: :exercise2,
    adapter: Ecto.Adapters.Postgres
end
