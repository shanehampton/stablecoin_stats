defmodule StablecoinStatsWeb.StatComponent do
  use StablecoinStatsWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="flex-vertical" style={"margin-top:4%; margin-bottom:4%; border-radius:6px; box-shadow: #{if @stat.is_high_score do @stat.primary_color else "#00000000" end} 0px 0px 0px 2.5px"}>
      <div class="flex-vertical" style="padding:1%; width:360px; height:230px; border-radius:6px 6px 0 0; background:rgba(255,255,255,0.1)">
        <div class="flex-horizontal" style="margin-top:2%">
          <img src={"/images/#{@stat.symbol}_logo.png"} height="53px" width="53px" style="margin-left: 2%">
          <div style="color:white; font-size:24px; margin-left:4%"><%=String.upcase(@stat.symbol)%></div>
          <div style="color:white; margin-left:10%; font-size:32px">$<%=:erlang.float_to_binary(@stat.price, [decimals: 6])%></div>
        </div>
        <div style="width:308px; height:112px; margin:auto">
          <%=@stat.sparkline%>
        </div>
      </div>
      <div class="flex-horizontal" style="margin-top:4px">
        <div class="flex-horizontal" style="color:white; padding:1%; width:230px; height:139px; border-radius:0 0 0 6px; background:rgba(255,255,255,0.1); column-gap:14px; justify-content:center">
          <div class="flex-vertical" style="color:white; font-size:11px; font-weight:lighter; align-items:flex-end; row-gap:26px">
            <div style="line-height:11px">
            <div class="tooltip">RMSE
                <div class="top">
                    <p style="margin-bottom:6px; font-weight:bold; font-size: 14px; line-height:110%">Root-Mean-Square Error</p>
                    <p style="margin-bottom:6px; font-size: 13px; line-height:106%">Measures the magnitude of error between the coin's price and its $1.00 peg</p>
                    <i></i>
                </div>
            </div>
            </div>
            <div style="line-height:11px">
              <div class="tooltip">STDEV
                  <div class="top">
                      <p style="margin-bottom:6px; font-weight:bold; font-size: 14px; line-height:110%">Standard Deviation</p>
                      <p style="margin-bottom:6px; font-size: 13px; line-height:106%">Measures the general variability of the coin's price</p>
                      <i></i>
                  </div>
              </div>
            </div>
            <div style="line-height:11px">
              <div class="tooltip">MDDN
                  <div class="top">
                      <p style="margin-bottom:6px; font-weight:bold; font-size: 14px; line-height:110%">Max Drawdown</p>
                      <p style="margin-bottom:6px; font-size: 13px; line-height:106%">Measures the maximum peak-to-trough price movement on a timeseries basis</p>
                      <i></i>
                  </div>
              </div>
            </div>
          </div>
          <div class="flex-vertical" style="color:white; font-size:11px; font-weight:lighter; align-items:flex-start; row-gap:26px;">
            <div style="line-height:11px"><%=:erlang.float_to_binary(@stat.rmse, [decimals: 6])%></div>
            <div style="line-height:11px"><%=:erlang.float_to_binary(@stat.stdev, [decimals: 6])%></div>
            <div style="line-height:11px"><%=:erlang.float_to_binary(@stat.drawdown, [decimals: 6])%></div>
          </div>
          <div class="flex-vertical" style="align-items:flex-start; row-gap:31px">
            <div style="height:7px; width:100px; background-color:rgba(255,255,255,0.1); border-radius:0 6px 6px 0">
              <div style={"height:7px; width:#{@stat.rmse_width}px; background-color:#{@stat.primary_color}; border-radius:0 6px 6px 0"}></div>
            </div>
            <div style="height:7px; width:100px; background-color:rgba(255,255,255,0.1); border-radius:0 6px 6px 0">
              <div style={"height:7px; width:#{@stat.stdev_width}px; background-color:#{@stat.primary_color}; border-radius:0 6px 6px 0"}></div>
            </div>
            <div style="height:7px; width:100px; background-color:rgba(255,255,255,0.1); border-radius:0 6px 6px 0">
              <div style={"height:7px; width:#{@stat.mddn_width}px; background-color:#{@stat.primary_color}; border-radius:0 6px 6px 0"}></div>
            </div>
          </div>
        </div>
        <div class="flex-vertical" style="margin-left:4px; color:white; padding:1%; width:126px; height:139px; border-radius:0 0 6px 0; background:rgba(255,255,255,0.1); align-items:center; justify-content:center; row-gap:8px">
          <div style="font-size:12px">
            <div class="tooltip">Stability Score
              <div class="top">
                  <%!-- <p style="margin-bottom:6px; font-weight:bold; font-size: 16px; line-height:110%">Stability Score</p> --%>
                  <p style="margin-bottom:6px; font-size: 13px; line-height:106%">A multi-factor score for the coin's overall price stability</p>
                  <i></i>
              </div>
            </div>
    
          </div>
          <%!-- <div style="font-size:40px"><%=:erlang.float_to_binary(@stat.score, [decimals: 2])%></div> --%>
          <div class="donutContainer" style="height:86px">
            <h2><%=:erlang.float_to_binary(@stat.score, [decimals: 2])%></h2>
            <svg width="86" height="86" xmlns="http://www.w3.org/2000/svg" style="transform: rotate(-90deg)">
            <g>
              <title>Layer 1</title>
              <circle cx="50%" cy="50%" r="40" fill="none" stroke="rgba(255,255,255,0.1)" stroke-width="6";></circle>
              <circle id="circle" style={"stroke-dashoffset:#{(10 - @stat.score) / 10 * 251}"} class="donut" r="40" cy="50%" cx="50%" stroke-width="6" stroke={"#{@stat.primary_color}"} fill="none"/>
            </g>
            </svg>
        </div>
        </div>
      </div>
    </div>
    """
  end
end
