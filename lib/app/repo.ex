defmodule SportsApp.Repo do
  use Ecto.Repo,
    otp_app: :sports_app,
    adapter: Ecto.Adapters.Postgres
end
