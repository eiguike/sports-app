alias SportsApp.Matches

mapping_league = fn (league) ->
  case league do
    "SP1" -> "La Liga"
    "SP2" -> "Segunda Divisón"
    "E0" -> "Premier League"
    "D1" -> "Bundesliga"
  end
end

transform_to_hash = fn ([_, league, season, date, home_team, away_team, fthg, ftag, ftr, hthg, htag, htr]) ->
  %Matches{
    league: mapping_league.(league),
    season: season,
    date: date,
    home_team: home_team,
    away_team: away_team,
    fthg: String.to_integer(fthg),
    ftag: String.to_integer(ftag),
    ftr: ftr,
    htag: String.to_integer(htag),
    hthg: String.to_integer(hthg),
    htr: htr
  }
end

insert_to_database = fn(data) ->
  transform_to_hash.(data)
  |> SportsApp.Repo.insert
end

File.read!("./resources/Data.csv")
|> String.split("\r\n")
|> Enum.map(&String.split(&1, ","))
|> Enum.filter(fn 
  ["" | _] -> false
  [""] -> false
  _ -> true
end)
|> Enum.map(&insert_to_database.(&1))
