defmodule SportsApp.RouterRpcTest do
  use ExUnit.Case

  alias SportsApp.RouterRpc
  alias SportsApp.MatchesParameters

  test "should return empty results for an invalid data structure" do
    response = RouterRpc.search_matches([], [])
    [{_, data_type} | _] = IEx.Info.info(response)

    assert data_type == "SportsApp.MatchesResponse"
    assert Map.has_key?(response, :matches)

    %{matches: data} = response

    assert Enum.empty?(data)
  end

  test "should return empty results for empty parameters" do
    message = MatchesParameters.new
    response = RouterRpc.search_matches(message, [])
    [{_, data_type} | _] = IEx.Info.info(response)

    assert data_type == "SportsApp.MatchesResponse"
    assert Map.has_key?(response, :matches)

    %{matches: data} = response

    assert Enum.empty?(data)
  end

  test "should return results with league as parameter" do
    message = MatchesParameters.new(league: "La Liga")
    response = RouterRpc.search_matches(message, [])
    [{_, data_type} | _] = IEx.Info.info(response)

    assert data_type == "SportsApp.MatchesResponse"
    assert Map.has_key?(response, :matches)

    %{matches: data} = response

    assert Enum.count(data) >= 1
  end

  test "should return results with season as parameter" do
    message = MatchesParameters.new(season: "201617")
    response = RouterRpc.search_matches(message, [])
    [{_, data_type} | _] = IEx.Info.info(response)

    assert data_type == "SportsApp.MatchesResponse"
    assert Map.has_key?(response, :matches)

    %{matches: data} = response

    assert Enum.count(data) >= 1
  end

  test "should return results with both parameters defined" do
    message = MatchesParameters.new(league: "La Liga", season: "201617")
    response = RouterRpc.search_matches(message, [])
    [{_, data_type} | _] = IEx.Info.info(response)

    assert data_type == "SportsApp.MatchesResponse"
    assert Map.has_key?(response, :matches)

    %{matches: data} = response

    assert Enum.count(data) >= 1
  end

  test "should return empty results for both parameters" do
    message = MatchesParameters.new(league: "La Liga", season: "201920")
    response = RouterRpc.search_matches(message, [])
    [{_, data_type} | _] = IEx.Info.info(response)

    assert data_type == "SportsApp.MatchesResponse"
    assert Map.has_key?(response, :matches)

    %{matches: data} = response

    assert Enum.empty?(data)
  end
end
