defmodule StablecoinStats.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      StablecoinStats.Repo,
      # Start the key-value process
      StablecoinStats.KV,
      # Start the Telemetry supervisor
      StablecoinStatsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: StablecoinStats.PubSub},
      # Start the exchange websocket superivsor
      {StablecoinStats.ExchangeSupervisor, name: StablecoinStats.ExchangeSupervisor},
      # Start the Core service
      StablecoinStats.Core,
      # Start the Endpoint (http/https)
      StablecoinStatsWeb.Endpoint
      # Start a worker by calling: StablecoinStats.Worker.start_link(arg)
      # {StablecoinStats.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: StablecoinStats.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    StablecoinStatsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
