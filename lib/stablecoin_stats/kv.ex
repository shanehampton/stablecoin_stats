defmodule StablecoinStats.KV do
  use GenServer
  require Logger

  @me __MODULE__

  @moduledoc """
  Implement a simple key-value store as a server. This
  version creates a named server, so there is no need
  to pass the server pid to the API calls.
  """

  #######
  # API #
  #######

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  @doc """
  Create the key-value store. The optional parameter
  is a collection of key-value pairs which can be used to
  populate the store.
      iex> KV.start dave: "thomas"
      iex> KV.get :dave
      "thomas"
      iex> KV.stop
      :ok
  """

  def start_link(default \\ []) do
    GenServer.start_link(__MODULE__, default, name: @me)
  end

  @spec set(any, any) :: :ok
  @doc """
  Add or update the entry associated with key.
      iex> KV.start dave: 123
      iex> KV.get :dave
      123
      iex> KV.set :dave, 456
      iex> KV.set :language, "elixir"
      iex> KV.get :dave
      456
      iex> KV.get :language
      "elixir"
      iex> KV.stop
      :ok
  """
  def set(key, value) do
    GenServer.cast(@me, {:set, key, value})
  end

  def set_rate(currency_pair, exchange, value) do
    Logger.debug("Setting rate for #{currency_pair}_#{exchange} to #{value}")
    GenServer.cast(@me, {:set_rate, currency_pair, exchange, value})
  end

  def calc_price(symbol) do
    GenServer.call(@me, {:calc_price, symbol})
  end

  @doc """
  Return the value associated with `key`, or `nil`
  is there is none.
      iex> KV.start dave: 123
      iex> KV.get :dave
      123
      iex> KV.get :language
      nil
      iex> KV.stop
      :ok
  """
  def get(key) do
    GenServer.call(@me, {:get, key})
  end

  @doc """
  Return a sorted list of keys in the store.
      iex> KV.start dave: 123
      iex> KV.keys
      [ :dave ]
      iex> KV.set :language, "elixir"
      iex> KV.keys
      [ :dave, :language ]
      iex> KV.set :author, :jose
      iex> KV.keys
      [ :author, :dave, :language ]
      iex> KV.stop
      :ok
  """

  def keys do
    GenServer.call(@me, {:keys})
  end

  @doc """
  Delete the entry corresponding to a key from the store
  
      iex> KV.start dave: 123
      iex> KV.set :language, "elixir"
      iex> KV.keys
      [ :dave, :language ]
      iex> KV.delete :dave
      iex> KV.keys
      [ :language ]
      iex> KV.delete :language
      iex> KV.keys
      [ ]
      iex> KV.delete :unknown
      iex> KV.keys
      [ ]
      iex> KV.stop
      :ok
  """

  def delete(key) do
    GenServer.cast(@me, {:remove, key})
  end

  def stop do
    GenServer.stop(@me)
  end

  #######################
  # Server Implemention #
  #######################

  def init(args) do
    Logger.info("Initializing KV")

    {btc_usd_binance, btc_usd_bitstamp, btc_usd_coinbase, busd_usd_binance, usdc_usd_binance,
     usdc_usd_bitstamp, usdt_usd_binance, usdt_usd_bitstamp, btc_busd_binance, btc_usdc_binance,
     btc_usdc_bitstamp, btc_usdt_binance, btc_usdt_bitstamp,
     btc_usdt_coinbase} = StablecoinStats.DB.get_latest_rates()

    btc_usd = %{
      "binance" => btc_usd_binance.value,
      "bitstamp" => btc_usd_bitstamp.value,
      "coinbase" => btc_usd_coinbase.value
    }

    busd_usd = %{
      "binance" => busd_usd_binance.value
    }

    usdc_usd = %{
      "binance" => usdc_usd_binance.value,
      "bitstamp" => usdc_usd_bitstamp.value
    }

    usdt_usd = %{
      "binance" => usdt_usd_binance.value,
      "bitstamp" => usdt_usd_bitstamp.value
    }

    btc_busd = %{
      "binance" => btc_busd_binance.value
    }

    btc_usdc = %{
      "binance" => btc_usdc_binance.value,
      "bitstamp" => btc_usdc_bitstamp.value
    }

    btc_usdt = %{
      "binance" => btc_usdt_binance.value,
      "bitstamp" => btc_usdt_bitstamp.value,
      "coinbase" => btc_usdt_coinbase.value
    }

    {busd_prices, usdc_prices, usdt_prices} = StablecoinStats.DB.get_stablecoin_prices(1000)

    StablecoinStats.KV.set("btc_usd", btc_usd)
    StablecoinStats.KV.set("busd_usd", busd_usd)
    StablecoinStats.KV.set("usdc_usd", usdc_usd)
    StablecoinStats.KV.set("usdt_usd", usdt_usd)
    StablecoinStats.KV.set("btc_busd", btc_busd)
    StablecoinStats.KV.set("btc_usdc", btc_usdc)
    StablecoinStats.KV.set("btc_usdt", btc_usdt)
    StablecoinStats.KV.set("busd", List.first(busd_prices))
    StablecoinStats.KV.set("busd_history", busd_prices)
    StablecoinStats.KV.set("usdc", List.first(usdc_prices))
    StablecoinStats.KV.set("usdc_history", usdc_prices)
    StablecoinStats.KV.set("usdt", List.first(usdt_prices))
    StablecoinStats.KV.set("usdt_history", usdt_prices)
    {:ok, Enum.into(args, %{})}
  end

  def handle_cast({:set, key, value}, state) do
    {:noreply, Map.put(state, key, value)}
  end

  def handle_cast({:set_rate, currency_pair, exchange, value}, state) do
    {:noreply, put_in(state, [currency_pair, exchange], value)}
  end

  def handle_cast({:remove, key}, state) do
    {:noreply, Map.delete(state, key)}
  end

  def handle_call({:get, key}, _from, state) do
    {:reply, state[key], state}
  end

  def handle_call({:keys}, _from, state) do
    {:reply, Map.keys(state), state}
  end

  def handle_call({:calc_price, symbol}, _from, state) do
    # price = average of direct rate and BTC-interpolated rate
    btc_usd = calc_rate("btc_usd", state)
    btc_symbol = calc_rate("btc_#{symbol}", state)
    symbol_usd = calc_rate("#{symbol}_usd", state)
    price = (symbol_usd + btc_usd / btc_symbol) / 2

    Logger.debug(
      "Calculating price for #{symbol}:\n#{symbol}_usd = #{symbol_usd} | btc_#{symbol} = #{btc_symbol} | btc_usd = #{btc_usd} | price = #{price}"
    )

    prices = [
      price
      | Enum.take(
          Map.get(state, "#{symbol}_history"),
          length(Map.get(state, "#{symbol}_history")) - 1
        )
    ]

    # update price state
    state = Map.put(state, symbol, price)
    state = Map.put(state, "#{symbol}_history", prices)

    {:reply, prices, state}
  end

  def calc_rate(currency_pair, state) do
    rates = Map.get(state, currency_pair) |> Map.values()
    Enum.sum(rates) / length(rates)
  end
end
