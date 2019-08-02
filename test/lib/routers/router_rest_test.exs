defmodule SportsApp.RouterRestTest do
  use ExUnit.Case
  use Plug.Test

  alias SportsApp.RouterRest

  # GET /ping
  test "GET /ping" do
    %{status: status, resp_body: body} = get_response(:get, "/ping")
    assert status == 200
    assert body == Poison.encode!%{response: "ok"}
  end

  # GET /matches
  test "should respond 400 without parameters" do
    %{status: status, resp_body: body} = get_response(:get, "/matches")
    assert status == 400
    assert body == Poison.encode!%{response: "bad request, missing fields", fields: ["league","season"]}
  end

  test "should respond 400 when using unknown parameter" do
    %{status: status, resp_body: body} = get_response(:get, "/matches?unknown=league")
    assert status == 400
    assert body == Poison.encode!%{response: "bad request, missing fields", fields: ["league","season"]}
  end

  test "should respond 200 and list the matches with the parameter league" do
    %{status: status, resp_body: body} = get_response(:get, "/matches?league=La Liga")

    assert status == 200
    assert Map.has_key?(Poison.decode!(body), "matches")

    %{"matches" => matches} = Poison.decode!(body)
    assert Enum.count(matches) >= 1
  end

  test "should respond 200 and list the matches with the parameter season" do
    %{status: status, resp_body: body} = get_response(:get, "/matches?season=201617")

    assert status == 200
    assert Map.has_key?(Poison.decode!(body), "matches")

    %{"matches" => matches} = Poison.decode!(body)
    assert Enum.count(matches) >= 1
  end

  test "should respond 200 and list the matches both parameters (league and season)" do
    %{status: status, resp_body: body} = get_response(:get, "/matches?league=La Liga&season=201617")

    assert status == 200
    assert Map.has_key?(Poison.decode!(body), "matches")

    %{"matches" => matches} = Poison.decode!(body)
    assert Enum.count(matches) >= 1
  end

  test "should respond 404 when there are no results" do
    %{status: status, resp_body: body} = get_response(:get, "/matches?league=La Liga&season=201920")

    assert status == 404
    assert Map.has_key?(Poison.decode!(body), "matches")

    %{"matches" => matches} = Poison.decode!(body)
    assert Enum.count(matches) == 0 
  end

  # Others tests
  test "should respond 404 for unknown resources" do
    %{status: status, resp_body: body} = get_response(:get, "/unknown-resources")
    assert status == 404
    assert body == Poison.encode!%{response: "resource not found"}
  end

  test "should respond 404 for unknown resources for any verbs" do
    %{status: status, resp_body: body} = get_response(:post, "/unknown-resources")
    assert status == 404
    assert body == Poison.encode!%{response: "resource not found"}
  end

  def get_response(verb, route) do
    response = conn(verb, route)
               |> RouterRest.call([])
  end
end
