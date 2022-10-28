defmodule StablecoinStats.DBFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `StablecoinStats.DB` context.
  """

  @doc """
  Generate a stat.
  """
  def stat_fixture(attrs \\ %{}) do
    {:ok, stat} =
      attrs
      |> Enum.into(%{
        date: "some date",
        drawdown: 120.5,
        price: 120.5,
        rmse: 120.5,
        score: 120.5,
        symbol: "some symbol",
        variance: 120.5
      })
      |> StablecoinStats.DB.create_stat()

    stat
  end

  @doc """
  Generate a trade.
  """
  def trade_fixture(attrs \\ %{}) do
    {:ok, trade} =
      attrs
      |> Enum.into(%{
        currency_pair: "some currency_pair",
        date: "some date",
        exchange: "some exchange",
        price: 120.5
      })
      |> StablecoinStats.DB.create_trade()

    trade
  end
end
