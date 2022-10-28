defmodule StablecoinStats.Repo.Migrations.CreateRates do
  use Ecto.Migration

  def change do
    create table(:rates) do
      add :exchange, :string
      add :currency_pair, :string
      add :date, :utc_datetime
      add :value, :float

      timestamps()
    end
  end
end
