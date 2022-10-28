defmodule StablecoinStats.Repo do
  use Ecto.Repo,
    otp_app: :stablecoin_stats,
    adapter: Ecto.Adapters.Postgres
end
