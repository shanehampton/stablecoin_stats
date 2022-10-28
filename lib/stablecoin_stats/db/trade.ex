defmodule StablecoinStats.DB.Trade do
  use Ecto.Schema
  import Ecto.Changeset

  schema "trades" do
    field :currency_pair, :string
    field :date, :string
    field :exchange, :string
    field :price, :float

    timestamps()
  end

  @doc false
  def changeset(trade, attrs) do
    trade
    |> cast(attrs, [:exchange, :currency_pair, :date, :price])
    |> validate_required([:exchange, :currency_pair, :date, :price])
  end
end
