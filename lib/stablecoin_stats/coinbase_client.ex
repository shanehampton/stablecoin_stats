defmodule StablecoinStats.CoinbaseClient do
  alias StablecoinStats.Exchanges
  alias StablecoinStats.Client
  require Client

  @currency_pair_map %{
    "BTC-USD" => "btc_usd",
    "BTC-USDT" => "btc_usdt"
  }

  Client.defclient(
    exchange_name: "coinbase",
    host: 'ws-feed.pro.coinbase.com',
    port: 443,
    currency_pairs: [
      "BTC-USDT",
      "BTC-USD"
    ],
    path: "/ws"
  )

  @impl true
  def subscription_frames(currency_pairs) do
    msg =
      %{
        "type" => "subscribe",
        "product_ids" => currency_pairs,
        "channels" => ["ticker"]
      }
      |> Jason.encode!()

    [{:text, msg}]
  end

  @impl true
  def handle_ws_message(%{"type" => "ticker"} = msg, state) do
    {:ok, rate} = message_to_rate(msg)
    Exchanges.broadcast(rate)
    {:noreply, state}
  end

  @impl true
  def handle_ws_message(msg, state) do
    Logger.info("Unhandled ws message from coinbase:\n#{inspect(msg)}")
    {:noreply, state}
  end

  @spec message_to_rate(map()) :: {:ok, Map.t()} | {:error, any()}
  def message_to_rate(msg) do
    {:ok, date, _} = DateTime.from_iso8601(msg["time"])
    {value, ""} = Float.parse(msg["best_bid"])

    {:ok,
     %{
       exchange: "coinbase",
       currency_pair: @currency_pair_map[msg["product_id"]],
       value: value,
       date: date
     }}
  end
end
