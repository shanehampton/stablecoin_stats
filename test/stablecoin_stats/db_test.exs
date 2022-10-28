defmodule StablecoinStats.DBTest do
  use StablecoinStats.DataCase

  alias StablecoinStats.DB

  describe "stats" do
    alias StablecoinStats.DB.Stat

    import StablecoinStats.DBFixtures

    @invalid_attrs %{date: nil, drawdown: nil, price: nil, rmse: nil, score: nil, symbol: nil, variance: nil}

    test "list_stats/0 returns all stats" do
      stat = stat_fixture()
      assert DB.list_stats() == [stat]
    end

    test "get_stat!/1 returns the stat with given id" do
      stat = stat_fixture()
      assert DB.get_stat!(stat.id) == stat
    end

    test "create_stat/1 with valid data creates a stat" do
      valid_attrs = %{date: "some date", drawdown: 120.5, price: 120.5, rmse: 120.5, score: 120.5, symbol: "some symbol", variance: 120.5}

      assert {:ok, %Stat{} = stat} = DB.create_stat(valid_attrs)
      assert stat.date == "some date"
      assert stat.drawdown == 120.5
      assert stat.price == 120.5
      assert stat.rmse == 120.5
      assert stat.score == 120.5
      assert stat.symbol == "some symbol"
      assert stat.variance == 120.5
    end

    test "create_stat/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = DB.create_stat(@invalid_attrs)
    end

    test "update_stat/2 with valid data updates the stat" do
      stat = stat_fixture()
      update_attrs = %{date: "some updated date", drawdown: 456.7, price: 456.7, rmse: 456.7, score: 456.7, symbol: "some updated symbol", variance: 456.7}

      assert {:ok, %Stat{} = stat} = DB.update_stat(stat, update_attrs)
      assert stat.date == "some updated date"
      assert stat.drawdown == 456.7
      assert stat.price == 456.7
      assert stat.rmse == 456.7
      assert stat.score == 456.7
      assert stat.symbol == "some updated symbol"
      assert stat.variance == 456.7
    end

    test "update_stat/2 with invalid data returns error changeset" do
      stat = stat_fixture()
      assert {:error, %Ecto.Changeset{}} = DB.update_stat(stat, @invalid_attrs)
      assert stat == DB.get_stat!(stat.id)
    end

    test "delete_stat/1 deletes the stat" do
      stat = stat_fixture()
      assert {:ok, %Stat{}} = DB.delete_stat(stat)
      assert_raise Ecto.NoResultsError, fn -> DB.get_stat!(stat.id) end
    end

    test "change_stat/1 returns a stat changeset" do
      stat = stat_fixture()
      assert %Ecto.Changeset{} = DB.change_stat(stat)
    end
  end

  describe "trades" do
    alias StablecoinStats.DB.Trade

    import StablecoinStats.DBFixtures

    @invalid_attrs %{currency_pair: nil, date: nil, exchange: nil, price: nil}

    test "list_trades/0 returns all trades" do
      trade = trade_fixture()
      assert DB.list_trades() == [trade]
    end

    test "get_trade!/1 returns the trade with given id" do
      trade = trade_fixture()
      assert DB.get_trade!(trade.id) == trade
    end

    test "create_trade/1 with valid data creates a trade" do
      valid_attrs = %{currency_pair: "some currency_pair", date: "some date", exchange: "some exchange", price: 120.5}

      assert {:ok, %Trade{} = trade} = DB.create_trade(valid_attrs)
      assert trade.currency_pair == "some currency_pair"
      assert trade.date == "some date"
      assert trade.exchange == "some exchange"
      assert trade.price == 120.5
    end

    test "create_trade/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = DB.create_trade(@invalid_attrs)
    end

    test "update_trade/2 with valid data updates the trade" do
      trade = trade_fixture()
      update_attrs = %{currency_pair: "some updated currency_pair", date: "some updated date", exchange: "some updated exchange", price: 456.7}

      assert {:ok, %Trade{} = trade} = DB.update_trade(trade, update_attrs)
      assert trade.currency_pair == "some updated currency_pair"
      assert trade.date == "some updated date"
      assert trade.exchange == "some updated exchange"
      assert trade.price == 456.7
    end

    test "update_trade/2 with invalid data returns error changeset" do
      trade = trade_fixture()
      assert {:error, %Ecto.Changeset{}} = DB.update_trade(trade, @invalid_attrs)
      assert trade == DB.get_trade!(trade.id)
    end

    test "delete_trade/1 deletes the trade" do
      trade = trade_fixture()
      assert {:ok, %Trade{}} = DB.delete_trade(trade)
      assert_raise Ecto.NoResultsError, fn -> DB.get_trade!(trade.id) end
    end

    test "change_trade/1 returns a trade changeset" do
      trade = trade_fixture()
      assert %Ecto.Changeset{} = DB.change_trade(trade)
    end
  end
end
