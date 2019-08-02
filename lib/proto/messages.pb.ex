defmodule SportsApp.MatchesParameters do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          league: String.t(),
          season: String.t()
        }
  defstruct [:league, :season]

  field :league, 1, type: :string
  field :season, 2, type: :string
end

defmodule SportsApp.MatchesResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          matches: [SportsApp.Match.t()]
        }
  defstruct [:matches]

  field :matches, 1, repeated: true, type: SportsApp.Match
end

defmodule SportsApp.Match do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          league: String.t(),
          season: String.t(),
          date: String.t(),
          home_team: String.t(),
          away_team: String.t(),
          fthg: integer,
          ftag: integer,
          ftr: String.t(),
          hthg: integer,
          htag: integer,
          htr: String.t()
        }
  defstruct [
    :league,
    :season,
    :date,
    :home_team,
    :away_team,
    :fthg,
    :ftag,
    :ftr,
    :hthg,
    :htag,
    :htr
  ]

  field :league, 1, type: :string
  field :season, 2, type: :string
  field :date, 3, type: :string
  field :home_team, 4, type: :string
  field :away_team, 5, type: :string
  field :fthg, 6, type: :int32
  field :ftag, 7, type: :int32
  field :ftr, 8, type: :string
  field :hthg, 9, type: :int32
  field :htag, 10, type: :int32
  field :htr, 11, type: :string
end

defmodule SportsApp.MatchesService.Service do
  @moduledoc false
  use GRPC.Service, name: "sports_app.MatchesService"

  rpc :SearchMatches,
      SportsApp.MatchesParameters,
      SportsApp.MatchesResponse
end

defmodule SportsApp.MatchesService.Stub do
  @moduledoc false
  use GRPC.Stub, service: SportsApp.MatchesService.Service
end
