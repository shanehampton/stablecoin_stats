defmodule StablecoinStats.Core do
  use GenServer
  require Logger

  alias StablecoinStats.KV
  alias StablecoinStats.DB
  @stats_topic "stats"

  def start_link(_arg) do
    GenServer.start_link(__MODULE__, name: __MODULE__)
  end

  def init(state) do
    Logger.info("Initializing Core")
    StablecoinStats.Exchanges.subscribe()
    {:ok, state}
  end

  def handle_info({:new_rate, rate}, state) do
    Logger.debug("Received :new_rate message from PubSub rates topic:\n#{inspect(rate)}")
    StablecoinStats.DB.put_rate(rate)
    KV.set_rate(rate.currency_pair, rate.exchange, rate.value)

    new_stats =
      case rate.currency_pair do
        "btc_usd" ->
          busd_prices = KV.calc_price("busd")
          usdc_prices = KV.calc_price("usdc")
          usdt_prices = KV.calc_price("usdt")
          busd_stat = generate_stat("busd", rate.date, busd_prices)
          usdc_stat = generate_stat("usdc", rate.date, usdc_prices)
          usdt_stat = generate_stat("usdt", rate.date, usdt_prices)
          [busd_stat, usdc_stat, usdt_stat]

        "busd_usd" ->
          busd_prices = KV.calc_price("busd")
          busd_stat = generate_stat("busd", rate.date, busd_prices)
          [busd_stat]

        "usdc_usd" ->
          usdc_prices = KV.calc_price("usdc")
          usdc_stat = generate_stat("usdc", rate.date, usdc_prices)
          [usdc_stat]

        "usdt_usd" ->
          usdt_prices = KV.calc_price("usdt")
          usdt_stat = generate_stat("usdt", rate.date, usdt_prices)
          [usdt_stat]

        "btc_busd" ->
          busd_prices = KV.calc_price("busd")
          busd_stat = generate_stat("busd", rate.date, busd_prices)
          [busd_stat]

        "btc_usdc" ->
          usdc_prices = KV.calc_price("usdc")
          usdc_stat = generate_stat("usdc", rate.date, usdc_prices)
          [usdc_stat]

        "btc_usdt" ->
          usdt_prices = KV.calc_price("usdt")
          usdt_stat = generate_stat("usdt", rate.date, usdt_prices)
          [usdt_stat]

        _ ->
          []
      end

    Enum.each(new_stats, &store_and_broadcast_stat/1)

    {:noreply, state}
  end

  def store_and_broadcast_stat(stat) do
    DB.create_stat(stat)
    broadcast_stat(stat)
  end

  def generate_stat(symbol, date, prices) do
    price = Enum.at(prices, 0)
    prices = Enum.reverse(prices)
    rmse = calc_rmse(prices)
    rmse_score = (1 - rmse / 0.02) * 10
    stdev = calc_stdev(prices)
    stdev_score = (1 - stdev / 0.005) * 10
    drawdown = calc_max_drawdown(prices)
    drawdown_score = (1 - drawdown / 0.01) * 10
    total_score = (rmse_score + stdev_score + drawdown_score) / 3

    stat = %{
      symbol: symbol,
      date: to_string(date),
      price: price,
      prices: prices,
      rmse: rmse,
      stdev: stdev,
      drawdown: drawdown,
      rmse_score: rmse_score,
      stdev_score: stdev_score,
      drawdown_score: drawdown_score,
      score: total_score
    }

    Logger.debug("Generated stat:\n#{inspect(stat)}")
    stat
  end

  def calc_rmse(prices) do
    squared_errors = for price <- prices, do: Float.pow(price - 1.0, 2)
    mean_squared_error = Enum.sum(squared_errors) / length(squared_errors)
    Float.pow(mean_squared_error, 0.5)
  end

  def calc_stdev(prices) do
    mean = Enum.sum(prices) / length(prices)
    terms = for price <- prices, do: Float.pow(price - mean, 2)
    variance = Enum.sum(terms) / length(terms)
    Float.pow(variance, 0.5)
  end

  def calc_max_drawdown(prices) do
    # get rolling max for price series
    rolling_max = for i <- 0..(length(prices) - 1), do: Enum.max(Enum.take(prices, i + 1))
    # element-wise difference between price and rolling max price
    drawdowns = for {p, m} <- Enum.zip(prices, rolling_max), do: abs(p - m)
    Enum.max(drawdowns)
  end

  def broadcast_stat(stat) do
    Logger.debug("Broadcasting :new_stat message to PubSub stats topic:\n#{inspect(stat)}")
    Phoenix.PubSub.broadcast(StablecoinStats.PubSub, @stats_topic, {:new_stat, stat})
  end

  @spec subscribe_to_stats :: :ok | {:error, {:already_registered, pid}}
  def subscribe_to_stats() do
    Logger.info("Subscribing to PubSub stats topic")
    Phoenix.PubSub.subscribe(StablecoinStats.PubSub, @stats_topic)
  end
end
