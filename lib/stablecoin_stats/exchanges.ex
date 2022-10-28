defmodule StablecoinStats.Exchanges do
  require Logger

  @rates_topic "rates"
  @clients [
    StablecoinStats.CoinbaseClient,
    StablecoinStats.BitstampClient,
    StablecoinStats.BinanceClient
  ]

  @spec clients() :: [module()]
  def clients, do: @clients

  @spec subscribe() :: :ok | {:error, term()}
  def subscribe() do
    Logger.info("Subscribing to PubSub rates topic")
    Phoenix.PubSub.subscribe(StablecoinStats.PubSub, @rates_topic)
  end

  @spec unsubscribe() :: :ok | {:error, term()}
  def unsubscribe() do
    Logger.info("Unsubscribing to PubSub rates topic")
    Phoenix.PubSub.unsubscribe(StablecoinStats.PubSub, @rates_topic)
  end

  @spec broadcast(Map.t()) :: :ok | {:error, term()}
  def broadcast(rate) do
    Logger.debug("Broadcasting :new_rate message to PubSub rates topic:\n#{inspect(rate)}")

    Phoenix.PubSub.broadcast(
      StablecoinStats.PubSub,
      @rates_topic,
      {:new_rate, rate}
    )
  end
end
