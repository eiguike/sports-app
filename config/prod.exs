use Mix.Config

config :sports_app, port: 4000
config :sports_app, ecto_repos: [SportsApp.Repo]

config :sports_app, SportsApp.Repo,
  database: "sports_app",
  username: System.get_env("DATABASE_USERNAME"),
  password: System.get_env("DATABASE_PASSWORD"),
  hostname: System.get_env("DATABASE_URL"),
  port: "5432"

config :grpc, start_server: true
