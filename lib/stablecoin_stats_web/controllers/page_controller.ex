defmodule StablecoinStatsWeb.PageController do
  use StablecoinStatsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", name: "World")
  end
end
