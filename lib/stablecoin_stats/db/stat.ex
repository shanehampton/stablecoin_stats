defmodule StablecoinStats.DB.Stat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stats" do
    field :date, :string
    field :drawdown, :float
    field :drawdown_score, :float
    field :price, :float
    field :rmse, :float
    field :rmse_score, :float
    field :score, :float
    field :symbol, :string
    field :stdev, :float
    field :stdev_score, :float

    timestamps()
  end

  @doc false
  def changeset(stat, attrs) do
    stat
    |> cast(attrs, [
      :symbol,
      :date,
      :price,
      :rmse,
      :rmse_score,
      :stdev,
      :stdev_score,
      :drawdown,
      :drawdown_score,
      :score
    ])
    |> validate_required([:symbol, :date, :price])
  end
end
