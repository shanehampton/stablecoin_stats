defmodule StablecoinStats.Repo.Migrations.AddStdevToStats do
  use Ecto.Migration

  def change do
    alter table(:stats) do
      remove :variance
      remove :variance_score
      add :stdev, :float
      add :stdev_score, :float
    end
  end
end
