defmodule StablecoinStatsWeb.PageController do
  use StablecoinStatsWeb, :controller

  def index(conn, _params) do
    version = Application.spec(:stablecoin_stats)[:vsn]
    render(conn, "index.html", version: version)
  end
end
