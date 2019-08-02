alias SportsApp.Handlers.Ping
alias SportsApp.Handlers.Matches
alias SportsApp.Metrics

defmodule SportsApp.RouterRest do
  use Plug.Router
  use Plug.ErrorHandler

  plug Metrics.Exporter
  plug(Plug.Logger)
  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  plug(:dispatch)

  get "/ping" do
    Ping.handle()
    |> format_message(conn)
  end

  get "/matches" do
    %{ params: params } = conn
    Matches.handle(params)
    |> format_message(conn)
  end

  match _ do
    [
      %{response: "resource not found"},
      404
    ] |> format_message(conn)
  end

  defp handle_errors(conn, %{kind: _kind, reason: _reason, stack: _stack}) do
    [
      %{response: "opps... something went wrong"},
      conn.status
    ] |> format_message(conn)
  end

  defp format_message([body, status_code], conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status_code, Poison.encode!(body))
  end
end
