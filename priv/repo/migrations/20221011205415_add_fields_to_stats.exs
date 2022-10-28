defmodule StablecoinStats.Repo.Migrations.AddFieldsToStats do
  use Ecto.Migration

  def change do
    alter table(:stats) do
      add :rmse_score, :float
      add :variance_score, :float
      add :drawdown_score, :float
    end
  end
end
