defmodule StablecoinStats.DB do
  @moduledoc """
  The DB context.
  """

  import Ecto.Query, warn: false
  alias StablecoinStats.Repo
  alias StablecoinStats.DB.Stat
  alias StablecoinStats.DB.Trade
  alias StablecoinStats.DB.Rate
  require Logger

  def get_latest_stats() do
    query = from(s in Stat, where: s.symbol == "busd", limit: 1, order_by: [desc: s.date])

    busd_stat = Repo.one(query)

    query = from(s in Stat, where: s.symbol == "usdc", limit: 1, order_by: [desc: s.date])

    usdc_stat = Repo.one(query)

    query = from(s in Stat, where: s.symbol == "usdt", limit: 1, order_by: [desc: s.date])

    usdt_stat = Repo.one(query)
    {busd_stat, usdc_stat, usdt_stat}
  end

  def get_latest_rates do
    query =
      from(r in Rate,
        select: r,
        where: r.currency_pair == "btc_usd" and r.exchange == "binance",
        limit: 1,
        order_by: [desc: r.date]
      )

    btc_usd_binance = Repo.one(query)

    query =
      from(r in Rate,
        select: r,
        where: r.currency_pair == "btc_usd" and r.exchange == "bitstamp",
        limit: 1,
        order_by: [desc: r.date]
      )

    btc_usd_bitstamp = Repo.one(query)

    query =
      from(r in Rate,
        select: r,
        where: r.currency_pair == "btc_usd" and r.exchange == "coinbase",
        limit: 1,
        order_by: [desc: r.date]
      )

    btc_usd_coinbase = Repo.one(query)

    query =
      from(r in Rate,
        select: r,
        where: r.currency_pair == "busd_usd" and r.exchange == "binance",
        limit: 1,
        order_by: [desc: r.date]
      )

    busd_usd_binance = Repo.one(query)

    query =
      from(r in Rate,
        select: r,
        where: r.currency_pair == "btc_busd" and r.exchange == "binance",
        limit: 1,
        order_by: [desc: r.date]
      )

    btc_busd_binance = Repo.one(query)

    query =
      from(r in Rate,
        select: r,
        where: r.currency_pair == "usdc_usd" and r.exchange == "binance",
        limit: 1,
        order_by: [desc: r.date]
      )

    usdc_usd_binance = Repo.one(query)

    query =
      from(r in Rate,
        select: r,
        where: r.currency_pair == "usdc_usd" and r.exchange == "bitstamp",
        limit: 1,
        order_by: [desc: r.date]
      )

    usdc_usd_bitstamp = Repo.one(query)

    query =
      from(r in Rate,
        select: r,
        where: r.currency_pair == "usdt_usd" and r.exchange == "binance",
        limit: 1,
        order_by: [desc: r.date]
      )

    usdt_usd_binance = Repo.one(query)

    query =
      from(r in Rate,
        select: r,
        where: r.currency_pair == "usdt_usd" and r.exchange == "bitstamp",
        limit: 1,
        order_by: [desc: r.date]
      )

    usdt_usd_bitstamp = Repo.one(query)

    query =
      from(r in Rate,
        select: r,
        where: r.currency_pair == "btc_usdt" and r.exchange == "coinbase",
        limit: 1,
        order_by: [desc: r.date]
      )

    btc_usdt_coinbase = Repo.one(query)

    query =
      from(r in Rate,
        select: r,
        where: r.currency_pair == "btc_usdc" and r.exchange == "binance",
        limit: 1,
        order_by: [desc: r.date]
      )

    btc_usdc_binance = Repo.one(query)

    query =
      from(r in Rate,
        select: r,
        where: r.currency_pair == "btc_usdc" and r.exchange == "bitstamp",
        limit: 1,
        order_by: [desc: r.date]
      )

    btc_usdc_bitstamp = Repo.one(query)

    query =
      from(r in Rate,
        select: r,
        where: r.currency_pair == "btc_usdt" and r.exchange == "binance",
        limit: 1,
        order_by: [desc: r.date]
      )

    btc_usdt_binance = Repo.one(query)

    query =
      from(r in Rate,
        select: r,
        where: r.currency_pair == "btc_usdt" and r.exchange == "bitstamp",
        limit: 1,
        order_by: [desc: r.date]
      )

    btc_usdt_bitstamp = Repo.one(query)

    {btc_usd_binance, btc_usd_bitstamp, btc_usd_coinbase, busd_usd_binance, usdc_usd_binance,
     usdc_usd_bitstamp, usdt_usd_binance, usdt_usd_bitstamp, btc_busd_binance, btc_usdc_binance,
     btc_usdc_bitstamp, btc_usdt_binance, btc_usdt_bitstamp, btc_usdt_coinbase}
  end

  def get_latest_rate_by_pair() do
    query =
      from(r in Rate,
        select: r,
        where: r.currency_pair == "btc_usd",
        limit: 1,
        order_by: [desc: r.date]
      )

    btc_usd = Repo.one(query)

    query =
      from(r in Rate,
        select: r,
        where: r.currency_pair == "busd_usd",
        limit: 1,
        order_by: [desc: r.date]
      )

    busd_usd = Repo.one(query)

    query =
      from(r in Rate,
        select: r,
        where: r.currency_pair == "usdc_usd",
        limit: 1,
        order_by: [desc: r.date]
      )

    usdc_usd = Repo.one(query)

    query =
      from(r in Rate,
        select: r,
        where: r.currency_pair == "usdt_usd",
        limit: 1,
        order_by: [desc: r.date]
      )

    usdt_usd = Repo.one(query)

    query =
      from(r in Rate,
        select: r,
        where: r.currency_pair == "btc_busd",
        limit: 1,
        order_by: [desc: r.date]
      )

    btc_busd = Repo.one(query)

    query =
      from(r in Rate,
        select: r,
        where: r.currency_pair == "btc_usdc",
        limit: 1,
        order_by: [desc: r.date]
      )

    btc_usdc = Repo.one(query)

    query =
      from(r in Rate,
        select: r,
        where: r.currency_pair == "btc_usdt",
        limit: 1,
        order_by: [desc: r.date]
      )

    btc_usdt = Repo.one(query)

    {btc_usd, busd_usd, usdc_usd, usdt_usd, btc_busd, btc_usdc, btc_usdt}
  end

  def get_stablecoin_prices(n) do
    query =
      from(s in Stat,
        select: s.price,
        where: s.symbol == "busd",
        limit: ^n,
        order_by: [desc: s.date]
      )

    busd_prices = Repo.all(query)

    query =
      from(s in Stat,
        select: s.price,
        where: s.symbol == "usdc",
        limit: ^n,
        order_by: [desc: s.date]
      )

    usdc_prices = Repo.all(query)

    query =
      from(s in Stat,
        select: s.price,
        where: s.symbol == "usdt",
        limit: ^n,
        order_by: [desc: s.date]
      )

    usdt_prices = Repo.all(query)

    if n == 1 do
      # Return the first element intead of a one-element list
      {Enum.at(busd_prices, 0), Enum.at(usdc_prices, 0), Enum.at(usdt_prices, 0)}
    else
      {busd_prices, usdc_prices, usdt_prices}
    end
  end

  @doc """
  Returns the list of stats.
  
  ## Examples
  
      iex> list_stats()
      [%Stat{}, ...]
  
  """
  def list_stats do
    Repo.all(Stat)
  end

  @doc """
  Gets a single stat.
  
  Raises `Ecto.NoResultsError` if the Stat does not exist.
  
  ## Examples
  
      iex> get_stat!(123)
      %Stat{}
  
      iex> get_stat!(456)
      ** (Ecto.NoResultsError)
  
  """
  def get_stat!(id), do: Repo.get!(Stat, id)

  @doc """
  Creates a stat.
  
  ## Examples
  
      iex> create_stat(%{field: value})
      {:ok, %Stat{}}
  
      iex> create_stat(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def create_stat(attrs \\ %{}) do
    Logger.debug("Storing stat in DB:\n#{inspect(attrs)}")

    %Stat{}
    |> Stat.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a stat.
  
  ## Examples
  
      iex> update_stat(stat, %{field: new_value})
      {:ok, %Stat{}}
  
      iex> update_stat(stat, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def update_stat(%Stat{} = stat, attrs) do
    stat
    |> Stat.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a stat.
  
  ## Examples
  
      iex> delete_stat(stat)
      {:ok, %Stat{}}
  
      iex> delete_stat(stat)
      {:error, %Ecto.Changeset{}}
  
  """
  def delete_stat(%Stat{} = stat) do
    Repo.delete(stat)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking stat changes.
  
  ## Examples
  
      iex> change_stat(stat)
      %Ecto.Changeset{data: %Stat{}}
  
  """
  def change_stat(%Stat{} = stat, attrs \\ %{}) do
    Stat.changeset(stat, attrs)
  end

  alias StablecoinStats.DB.Trade

  @doc """
  Returns the list of trades.
  
  ## Examples
  
      iex> list_trades()
      [%Trade{}, ...]
  
  """
  def list_trades do
    Repo.all(Trade)
  end

  @doc """
  Gets a single trade.
  
  Raises `Ecto.NoResultsError` if the Trade does not exist.
  
  ## Examples
  
      iex> get_trade!(123)
      %Trade{}
  
      iex> get_trade!(456)
      ** (Ecto.NoResultsError)
  
  """
  def get_trade!(id), do: Repo.get!(Trade, id)

  @doc """
  Creates a trade.
  
  ## Examples
  
      iex> create_trade(%{field: value})
      {:ok, %Trade{}}
  
      iex> create_trade(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def create_trade(attrs \\ %{}) do
    %Trade{}
    |> Trade.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a trade.
  
  ## Examples
  
      iex> update_trade(trade, %{field: new_value})
      {:ok, %Trade{}}
  
      iex> update_trade(trade, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def update_trade(%Trade{} = trade, attrs) do
    trade
    |> Trade.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a trade.
  
  ## Examples
  
      iex> delete_trade(trade)
      {:ok, %Trade{}}
  
      iex> delete_trade(trade)
      {:error, %Ecto.Changeset{}}
  
  """
  def delete_trade(%Trade{} = trade) do
    Repo.delete(trade)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking trade changes.
  
  ## Examples
  
      iex> change_trade(trade)
      %Ecto.Changeset{data: %Trade{}}
  
  """
  def change_trade(%Trade{} = trade, attrs \\ %{}) do
    Trade.changeset(trade, attrs)
  end

  @doc """
  Returns the list of rates.
  
  ## Examples
  
      iex> list_rates()
      [%Rate{}, ...]
  
  """
  def list_rates do
    Repo.all(Rate)
  end

  @doc """
  Gets a single rate.
  
  Raises `Ecto.NoResultsError` if the Rate does not exist.
  
  ## Examples
  
      iex> get_rate!(123)
      %Rate{}
  
      iex> get_rate!(456)
      ** (Ecto.NoResultsError)
  
  """
  def get_rate!(id), do: Repo.get!(Rate, id)

  @doc """
  Creates a rate.
  
  ## Examples
  
      iex> create_rate(%{field: value})
      {:ok, %Rate{}}
  
      iex> create_rate(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def create_rate(attrs \\ %{}) do
    %Rate{}
    |> Rate.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a rate.
  
  ## Examples
  
      iex> update_rate(rate, %{field: new_value})
      {:ok, %Rate{}}
  
      iex> update_rate(rate, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def update_rate(%Rate{} = rate, attrs) do
    rate
    |> Rate.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a rate.
  
  ## Examples
  
      iex> delete_rate(rate)
      {:ok, %Rate{}}
  
      iex> delete_rate(rate)
      {:error, %Ecto.Changeset{}}
  
  """
  def delete_rate(%Rate{} = rate) do
    Repo.delete(rate)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking rate changes.
  
  ## Examples
  
      iex> change_rate(rate)
      %Ecto.Changeset{data: %Rate{}}
  
  """
  def change_rate(%Rate{} = rate, attrs \\ %{}) do
    Rate.changeset(rate, attrs)
  end

  @spec put_rate(%{
          :currency_pair => any,
          :date => any,
          :exchange => any,
          :value => any,
          optional(any) => any
        }) :: any
  def put_rate(
        %{:exchange => exchange, :currency_pair => currency_pair, :date => date, :value => value} =
          attrs
      ) do
    Logger.debug("Updating rate in DB:\n#{inspect(attrs)}")

    from(r in Rate,
      where: r.exchange == ^exchange and r.currency_pair == ^currency_pair,
      update: [set: [value: ^value, date: ^date]]
    )
    |> Repo.update_all([])
  end
end
