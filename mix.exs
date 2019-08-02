defmodule SportsApp.MixProject do
  use Mix.Project

  def project do
    [
      app: :sports_app,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:prometheus_plugs, :prometheus_ex, :logger, :plug_cowboy, :grpc],
      mod: {SportsApp.Application, []}
    ]
  end

  defp deps do
    [
      {:plug_cowboy, "~> 2.0.2"},
      {:poison, "~> 3.1"},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:cowboy, github: "elixir-grpc/cowboy", override: true},
      {:gun, github: "elixir-grpc/gun", override: true},
      {:grpc, github: "elixir-grpc/grpc"},
      {:prometheus_ex, "~> 3.0"},
      {:prometheus_plugs, "~> 1.1.1"},
    ]
  end
end
