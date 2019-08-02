alias SportsApp.Matches
alias SportsApp.Repo

defmodule SportsApp.Handlers.Matches do
  import Ecto.Query

  def handle(%{"league" => league, "season" => season}) do
    Matches
    |> where([league: ^league, season: ^season])
    |> search_in_database
    |> format_response
  end

  def handle(%{"season" => season}) do
    Matches
    |> where(season: ^season)
    |> search_in_database
    |> format_response
  end

  def handle(%{"league" => league}) do
    Matches
    |> where(league: ^league)
    |> search_in_database
    |> format_response
  end

  def handle(%{}) do
    [
      %{response: "bad request, missing fields", fields: ["league", "season"]},
      400
    ]
  end

  defp search_in_database(data) do
    data
    |> Repo.all
    |> Enum.map(&filter_data(&1))
  end

  defp filter_data(data) do
    data
    |> Map.drop([:__meta__, :__struct__, :inserted_at, :updated_at])
  end

  defp format_response(data) do
    case data do
      [_|_] -> [ %{matches: data}, 200 ]
      [_] -> [ %{matches: data}, 200 ]
      [] -> [ %{matches: []}, 404 ]
      _ -> [ %{response: "something went wrong"}, 500 ]
    end
  end
end
