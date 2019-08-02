use Mix.Config

config :sports_app, port: 4000

config :sports_app, ecto_repos: [SportsApp.Repo]

config :sports_app, SportsApp.Repo,
  database: "sports_app_test",
  username: "postgres",
  password: "postgres",
  hostname: System.get_env("DATABASE_URL"),
  port: "5432"

config :grpc, start_server: true
