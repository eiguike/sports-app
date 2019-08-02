defmodule SportsApp.Application do
  @moduledoc false
  use Application

  alias SportsApp.Metrics

  def start(_type, _args) do
    import Supervisor.Spec

    Metrics.Initializer.setup()

    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: SportsApp.RouterRest,
        options: [port: Application.get_env(:sports_app, :port)]
      ),
      SportsApp.Repo,
      supervisor(GRPC.Server.Supervisor, [{SportsApp.RouterRpc, 8080}])
    ]

    opts = [strategy: :one_for_one, name: SportsApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
