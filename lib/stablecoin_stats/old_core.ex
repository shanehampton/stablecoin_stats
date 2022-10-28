defmodule StablecoinStats.OldCore do
  use GenServer

  alias StablecoinStats.KV
  @stats_topic "stats"

  def start_link(_arg) do
    GenServer.start_link(__MODULE__, name: __MODULE__)
  end

  def init(arg) do
    IO.puts("initializing StablecoinStats.OldCore...")
    StablecoinStats.Exchanges.subscribe()
    {:ok, arg}
  end

  def handle_info({:new_trade, trade}, state) do
    kv_state = %{
      btc_usd: KV.get(:btc_usd),
      btc_usdc: KV.get(:btc_usdc),
      btc_usdt: KV.get(:btc_usdt),
      usdc: KV.get(:usdc),
      usdt: KV.get(:usdt),
      usdc_history: KV.get(:usdc_history),
      usdt_history: KV.get(:usdt_history)
    }

    IO.puts("incoming #{trade.currency_pair} trade, KV state")
    IO.inspect(kv_state)

    # handle a new trade
    {price, ""} = Float.parse(trade.price)

    case trade.currency_pair do
      "BTC-USD" ->
        # set btc_usd in KV
        KV.set(:btc_usd, price)

        case {!!KV.get(:btc_usdc), !!KV.get(:btc_usdt)} do
          {true, true} ->
            # calc new price and stat for both
            IO.puts("case 1...")
            new_usdc_price = price / KV.get(:btc_usdc)
            IO.puts("new usdc price: #{new_usdc_price}")
            KV.set(:usdc, new_usdc_price)

            KV.set(:usdc_history, [
              new_usdc_price | Enum.take(KV.get(:usdc_history), length(KV.get(:usdc_history)) - 1)
            ])

            usdc_history = KV.get(:usdc_history)
            usdc_stat = StablecoinStats.OldCore.generate_stat("usdc", trade.date, usdc_history)
            StablecoinStats.DB.create_stat(usdc_stat)
            StablecoinStats.OldCore.broadcast_stat(usdc_stat)

            new_usdt_price = price / KV.get(:btc_usdt)
            IO.puts("new usdt price: #{new_usdt_price}")
            KV.set(:usdt, new_usdt_price)

            KV.set(:usdt_history, [
              new_usdt_price | Enum.take(KV.get(:usdt_history), length(KV.get(:usdt_history)) - 1)
            ])

            usdt_history = KV.get(:usdt_history)
            usdt_stat = StablecoinStats.OldCore.generate_stat("usdt", trade.date, usdt_history)
            StablecoinStats.DB.create_stat(usdt_stat)
            StablecoinStats.OldCore.broadcast_stat(usdt_stat)

            {:noreply, state}

          {true, false} ->
            # calc new price and stat for usdc
            IO.puts("case 2...")
            new_usdc_price = price / KV.get(:btc_usdc)
            IO.puts("new usdc price: #{new_usdc_price}")
            KV.set(:usdc, new_usdc_price)

            KV.set(:usdc_history, [
              new_usdc_price | Enum.take(KV.get(:usdc_history), length(KV.get(:usdc_history)) - 1)
            ])

            usdc_history = KV.get(:usdc_history)
            usdc_stat = StablecoinStats.OldCore.generate_stat("usdc", trade.date, usdc_history)
            StablecoinStats.DB.create_stat(usdc_stat)
            StablecoinStats.OldCore.broadcast_stat(usdc_stat)
            # update KV with interpolated btc_usdt
            KV.set(:btc_usdt, price / KV.get(:usdt))

            {:noreply, state}

          {false, true} ->
            # calc new price and stat for usdt
            IO.puts("case 3...")
            new_usdt_price = price / KV.get(:btc_usdt)
            IO.puts("new usdt price: #{new_usdt_price}")
            KV.set(:usdt, new_usdt_price)

            KV.set(:usdt_history, [
              new_usdt_price | Enum.take(KV.get(:usdt_history), length(KV.get(:usdt_history)) - 1)
            ])

            usdt_history = KV.get(:usdt_history)
            usdt_stat = StablecoinStats.OldCore.generate_stat("usdt", trade.date, usdt_history)
            StablecoinStats.DB.create_stat(usdt_stat)
            StablecoinStats.OldCore.broadcast_stat(usdt_stat)
            # update KV with interpolated btc_usdc
            KV.set(:btc_usdc, price / KV.get(:usdc))

            {:noreply, state}

          {false, false} ->
            # update KV with interpolated btc_usdc and btc_usdt
            KV.set(:btc_usdc, price / KV.get(:usdc))
            KV.set(:btc_usdt, price / KV.get(:usdt))

            {:noreply, state}
        end

      "btcusdc" ->
        KV.set(:btc_usdc, price)

        if KV.get(:btc_usd) do
          new_usdc_price = KV.get(:btc_usd) / price
          KV.set(:usdc, new_usdc_price)

          KV.set(:usdc_history, [
            new_usdc_price | Enum.take(KV.get(:usdc_history), length(KV.get(:usdc_history)) - 1)
          ])

          usdc_history = KV.get(:usdc_history)
          usdc_stat = StablecoinStats.OldCore.generate_stat("usdc", trade.date, usdc_history)
          StablecoinStats.DB.create_stat(usdc_stat)
          StablecoinStats.OldCore.broadcast_stat(usdc_stat)

          {:noreply, state}
        end

        {:noreply, state}

      "BTC-USDT" ->
        KV.set(:btc_usdt, price)

        if KV.get(:btc_usd) do
          new_usdt_price = KV.get(:btc_usd) / price
          KV.set(:usdt, new_usdt_price)

          # adjust the pice history
          KV.set(:usdt_history, [
            new_usdt_price | Enum.take(KV.get(:usdt_history), length(KV.get(:usdt_history)) - 1)
          ])

          usdt_history = KV.get(:usdt_history)

          usdt_stat = StablecoinStats.OldCore.generate_stat("usdt", trade.date, usdt_history)

          StablecoinStats.DB.create_stat(usdt_stat)
          StablecoinStats.OldCore.broadcast_stat(usdt_stat)

          {:noreply, state}
        end

        {:noreply, state}

      _ ->
        {:noreply, state}
    end
  end

  def generate_stat(symbol, date, prices) do
    IO.puts("generating stat....")
    price = Enum.at(prices, 0)
    prices = Enum.reverse(prices)
    rmse = calc_rmse(prices)
    rmse_score = (1 - rmse / 0.02) * 10
    stdev = calc_stdev(prices)
    stdev_score = (1 - stdev / 0.005) * 10
    drawdown = calc_max_drawdown(prices)
    drawdown_score = (1 - drawdown / 0.01) * 10
    total_score = (rmse_score + stdev_score + drawdown_score) / 3

    %{
      symbol: symbol,
      date: date,
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
    IO.puts("broadcasting new stat")
    IO.inspect(stat)
    Phoenix.PubSub.broadcast(StablecoinStats.PubSub, @stats_topic, {:new_stat, stat})
  end

  def subscribe_to_stats() do
    IO.puts("subscribing to new stats")
    Phoenix.PubSub.subscribe(StablecoinStats.PubSub, @stats_topic)
  end
end
