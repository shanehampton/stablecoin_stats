defmodule StablecoinStats.BinanceClient do
  alias StablecoinStats.Exchanges
  alias StablecoinStats.Client
  require Client

  @currency_pair_map %{
    "busdusd" => "busd_usd",
    "usdtusd" => "usdt_usd",
    "usdcusd" => "usdc_usd",
    "btcusd" => "btc_usd",
    "btcbusd" => "btc_busd",
    "btcusdt" => "btc_usdt",
    "btcusdc" => "btc_usdc"
  }

  Client.defclient(
    exchange_name: "binance",
    host: 'stream.binance.us',
    port: 9443,
    currency_pairs: [
      "busdusd",
      "usdtusd",
      "usdcusd",
      "btcusd",
      "btcbusd",
      "btcusdt",
      "btcusdc"
    ],
    path: "/ws"
  )

  @impl true
  def subscription_frames(currency_pairs) do
    params = for pair <- currency_pairs, do: "#{pair}@bookTicker"

    msg =
      %{
        "method" => "SUBSCRIBE",
        "params" => params,
        "id" => 1
      }
      |> Jason.encode!()

    [{:text, msg}]
  end

  @impl true
  def handle_ws_message(
        %{"A" => _, "a" => _, "B" => _, "b" => _, "s" => _, "u" => _} = msg,
        state
      ) do
    {:ok, rate} = message_to_rate(msg)
    Exchanges.broadcast(rate)
    {:noreply, state}
  end

  @impl true
  def handle_ws_message(msg, state) do
    Logger.info("Unhandled ws message from binance:\n#{inspect(msg)}")
    {:noreply, state}
  end

  @spec message_to_rate(map()) :: {:ok, Map.t()} | {:error, any()}
  def message_to_rate(msg) do
    # binance does not send a timestamp in @bookTicker messages, so we add our own
    {:ok, date} = DateTime.now("Etc/UTC")
    {value, ""} = Float.parse(msg["b"])

    {:ok,
     %{
       exchange: "binance",
       currency_pair: @currency_pair_map[String.downcase(msg["s"])],
       value: value,
       date: date
     }}
  end
end
