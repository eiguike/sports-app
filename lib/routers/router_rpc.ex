alias SportsApp.Handlers.Matches

defmodule SportsApp.RouterRpc do
  use GRPC.Server, service: SportsApp.MatchesService.Service

  def search_matches(request, _stream) do
    case request do
      %{ league: "", season: "" } -> Matches.handle(%{})
      %{ league: league, season: "" } -> Matches.handle(%{"league" => league})
      %{ league: "", season: season } -> Matches.handle(%{"season" => season})
      %{ league: league, season: season } -> Matches.handle(%{"league" => league, "season" => season})
      _ -> Matches.handle(%{})
    end
    |> format_message
  end


  defp format_message([%{response: _}, _]) do
    SportsApp.MatchesResponse.new
  end

  defp format_message([%{matches: matches}, _]) do
    array = Enum.map(matches, &create_matches_messages(&1))
    SportsApp.MatchesResponse.new(matches: array)
  end

  defp create_matches_messages(data) do
    SportsApp.Match.new(data)
  end
end
