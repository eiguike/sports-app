defmodule SportsApp.Repo.Migrations.CreateMatches do
  use Ecto.Migration

  def change do
    create table(:matches) do
      add(:league, :string, size: 100)
      add(:season, :string, size: 100)
      add(:date, :string, size: 100)
      add(:home_team, :string, size: 50)
      add(:away_team, :string, size: 50)
      add(:fthg, :integer)
      add(:ftag, :integer)
      add(:ftr, :string, size: 1)
      add(:hthg, :integer)
      add(:htag, :integer)
      add(:htr, :string, size: 1)

      timestamps()
    end
  end
end
