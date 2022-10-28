defmodule StablecoinStats.Repo.Migrations.CreateTrades do
  use Ecto.Migration

  def change do
    create table(:trades) do
      add :exchange, :string
      add :currency_pair, :string
      add :date, :string
      add :price, :float

      timestamps()
    end
  end
end
