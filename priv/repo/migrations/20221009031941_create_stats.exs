defmodule StablecoinStats.Repo.Migrations.CreateStats do
  use Ecto.Migration

  def change do
    create table(:stats) do
      add :symbol, :string
      add :date, :string
      add :price, :float
      add :rmse, :float
      add :variance, :float
      add :drawdown, :float
      add :score, :float

      timestamps()
    end
  end
end
