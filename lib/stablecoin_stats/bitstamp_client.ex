defmodule StablecoinStats.BitstampClient do
  alias StablecoinStats.Exchanges
  alias StablecoinStats.Client
  require Client
  require Logger

  @currency_pair_map %{
    "usdtusd" => "usdt_usd",
    "usdcusd" => "usdc_usd",
    "btcusd" => "btc_usd",
    "btcusdt" => "btc_usdt",
    "btcusdc" => "btc_usdc"
  }

  Client.defclient(
    exchange_name: "bitstamp",
    host: 'ws.bitstamp.net',
    port: 443,
    currency_pairs: [
      "btcusdc",
      "btcusd",
      "btcusdt",
      "usdcusd",
      "usdtusd"
    ],
    path: "/"
  )

  @impl true
  def subscription_frames(currency_pairs) do
    Enum.map(currency_pairs, &subscription_frame/1)
  end

  defp subscription_frame(currency_pair) do
    msg =
      %{
        "event" => "bts:subscribe",
        "data" => %{
          "channel" => "order_book_#{currency_pair}"
        }
      }
      |> Jason.encode!()

    {:text, msg}
  end

  @impl true
  def handle_ws_message(
        %{"channel" => "order_book_" <> _, "event" => "data"} = msg,
        state
      ) do
    {:ok, rate} = message_to_rate(msg)
    Exchanges.broadcast(rate)
    {:noreply, state}
  end

  @impl true
  def handle_ws_message(msg, state) do
    Logger.info("Unhandled ws message from bitstamp:\n#{inspect(msg)}")
    {:noreply, state}
  end

  @spec message_to_rate(map()) :: {:ok, Map.t()} | {:error, any()}
  def message_to_rate(%{"data" => data, "channel" => "order_book_" <> currency_pair} = _msg) do
    {:ok, date} = microtimestamp_to_datetime(data["microtimestamp"])
    {value, ""} = Float.parse(List.first(List.first(data["bids"])))

    {:ok,
     %{
       exchange: "bitstamp",
       currency_pair: @currency_pair_map[currency_pair],
       value: value,
       date: date
     }}
  end

  @spec microtimestamp_to_datetime(String.t()) :: {:ok, DateTime.t()} | {:error, atom()}
  defp microtimestamp_to_datetime(ts) do
    case Integer.parse(ts) do
      {timestamp, _} ->
        DateTime.from_unix(timestamp, :microsecond)

      :error ->
        {:error, :invalid_timestamp_string}
    end
  end
end
