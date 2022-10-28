defmodule StablecoinStats.DB.Rate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rates" do
    field :exchange, :string
    field :currency_pair, :string
    field :date, :utc_datetime
    field :value, :float

    timestamps()
  end

  @doc false
  def changeset(stat, attrs) do
    stat
    |> cast(attrs, [
      :exchange,
      :currency_pair,
      :date,
      :value
    ])
    |> validate_required([:exchange, :currency_pair, :date, :value])
  end
end
