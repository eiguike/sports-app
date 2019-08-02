defmodule SportsApp.Matches do
  use Ecto.Schema

  schema "matches" do
    field :league
    field :season
    field :date
    field :home_team
    field :away_team
    field :fthg, :integer
    field :ftag, :integer
    field :ftr
    field :hthg, :integer
    field :htag, :integer
    field :htr
    timestamps()
  end
end
