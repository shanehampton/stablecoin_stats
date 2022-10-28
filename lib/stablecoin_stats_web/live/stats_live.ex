defmodule StablecoinStatsWeb.StatsLive do
  use StablecoinStatsWeb, :live_view
  alias StablecoinStats.KV
  alias Contex.Sparkline
  alias StablecoinStats.DB
  alias StablecoinStats.Core

  @rmse_max 0.002
  @stdev_max 0.0005
  @mddn_max 0.003
  @max_bar_width 100

  def mount(_params, _session, socket) do
    {busd_stat, usdc_stat, usdt_stat} = DB.get_latest_stats()

    busd_history = KV.get("busd_history")
    busd_stat = Map.put(busd_stat, :price, Enum.at(busd_history, 0))
    busd_stat = Map.put(busd_stat, :prices, Enum.reverse(busd_history))
    busd_stat = Map.put(busd_stat, :is_high_score, false)
    busd_stat = add_template_values(busd_stat)

    usdc_history = KV.get("usdc_history")
    usdc_stat = Map.put(usdc_stat, :price, Enum.at(usdc_history, 0))
    usdc_stat = Map.put(usdc_stat, :prices, Enum.reverse(usdc_history))
    usdc_stat = Map.put(usdc_stat, :is_high_score, false)
    usdc_stat = add_template_values(usdc_stat)

    usdt_history = KV.get("usdt_history")
    usdt_stat = Map.put(usdt_stat, :price, Enum.at(usdt_history, 0))
    usdt_stat = Map.put(usdt_stat, :prices, Enum.reverse(usdt_history))
    usdt_stat = Map.put(usdt_stat, :is_high_score, false)
    usdt_stat = add_template_values(usdt_stat)
    socket = assign(socket, busd: busd_stat, usdc: usdc_stat, usdt: usdt_stat)
    if connected?(socket), do: Core.subscribe_to_stats()
    {:ok, socket}
  end

  def is_high_score(stat, socket) do
    case stat.symbol do
      "busd" ->
        stat.score > socket.assigns.usdc.score and stat.score > socket.assigns.usdt.score

      "usdc" ->
        stat.score > socket.assigns.busd.score and stat.score > socket.assigns.usdt.score

      "usdt" ->
        stat.score > socket.assigns.busd.score and stat.score > socket.assigns.usdc.score

      _ ->
        false
    end
  end

  def handle_info({:new_stat, stat}, socket) do
    stat = add_template_values(stat)
    stat = Map.put(stat, :is_high_score, is_high_score(stat, socket))

    socket =
      case stat.symbol do
        "busd" ->
          assign(socket, :busd, stat)

        "usdc" ->
          assign(socket, :usdc, stat)

        "usdt" ->
          assign(socket, :usdt, stat)

        _ ->
          socket
      end

    {:noreply, socket}
  end

  def add_template_values(stat) do
    primary_color =
      case stat.symbol do
        "usdc" -> "#2775CA"
        "usdt" -> "#50AF95"
        "busd" -> "#DEAC10"
        _ -> "#000000"
      end

    stat = Map.put(stat, :primary_color, primary_color)

    sparkline_opts = %{
      width: 308,
      height: 120,
      line_colour: primary_color,
      fill_colour: "#00000000",
      line_width: 1
    }

    sparkline =
      Sparkline.new(stat.prices)
      |> fill_sparkline_options(sparkline_opts)
      |> Sparkline.draw()

    rmse_width =
      if stat.rmse <= @rmse_max do
        stat.rmse / @rmse_max * @max_bar_width
      else
        @max_bar_width
      end

    stdev_width =
      if stat.stdev <= @stdev_max do
        stat.stdev / @stdev_max * @max_bar_width
      else
        @max_bar_width
      end

    mddn_width =
      if stat.drawdown <= @mddn_max do
        stat.drawdown / @mddn_max * @max_bar_width
      else
        @max_bar_width
      end

    stat = Map.put(stat, :sparkline, sparkline)
    stat = Map.put(stat, :rmse_width, rmse_width)
    stat = Map.put(stat, :stdev_width, stdev_width)
    stat = Map.put(stat, :mddn_width, mddn_width)

    stat
  end

  def fill_sparkline_options(chart, options) do
    chart =
      if options.width do
        %{chart | width: options.width}
      end

    chart =
      if options.height do
        %{chart | height: options.height}
      end

    chart =
      if options.line_colour do
        %{chart | line_colour: options.line_colour}
      end

    chart =
      if options.fill_colour do
        %{chart | fill_colour: options.fill_colour}
      end

    chart =
      if options.line_colour do
        %{chart | line_width: options.line_width}
      end

    chart
  end
end
