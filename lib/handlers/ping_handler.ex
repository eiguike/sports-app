defmodule SportsApp.Handlers.Ping do
  def handle() do
    [
      %{response: "ok"},
      200
    ]
  end
end
