defmodule StablecoinStats.ExchangeSupervisor do
  use Supervisor
  alias StablecoinStats.Exchanges
  require Logger

  def start_link(opts) do
    {clients, opts} = Keyword.pop(opts, :clients, Exchanges.clients())
    Supervisor.start_link(__MODULE__, clients, opts)
  end

  def init(clients) do
    Logger.info("Initializing ws clients:\n#{inspect(clients)}")
    Supervisor.init(clients, strategy: :one_for_one)
  end
end
