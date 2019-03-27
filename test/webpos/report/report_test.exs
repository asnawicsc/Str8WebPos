defmodule Webpos.ReportTest do
  use Webpos.DataCase

  alias Webpos.Report

  describe "orders" do
    alias Webpos.Report.Order

    @valid_attrs %{items: "some items", order_id: 42, organization_id: 42, rest_id: 42, salesdate: ~D[2010-04-17], salesdatetime: ~N[2010-04-17 14:00:00.000000], table_id: 42}
    @update_attrs %{items: "some updated items", order_id: 43, organization_id: 43, rest_id: 43, salesdate: ~D[2011-05-18], salesdatetime: ~N[2011-05-18 15:01:01.000000], table_id: 43}
    @invalid_attrs %{items: nil, order_id: nil, organization_id: nil, rest_id: nil, salesdate: nil, salesdatetime: nil, table_id: nil}

    def order_fixture(attrs \\ %{}) do
      {:ok, order} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Report.create_order()

      order
    end

    test "list_orders/0 returns all orders" do
      order = order_fixture()
      assert Report.list_orders() == [order]
    end

    test "get_order!/1 returns the order with given id" do
      order = order_fixture()
      assert Report.get_order!(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      assert {:ok, %Order{} = order} = Report.create_order(@valid_attrs)
      assert order.items == "some items"
      assert order.order_id == 42
      assert order.organization_id == 42
      assert order.rest_id == 42
      assert order.salesdate == ~D[2010-04-17]
      assert order.salesdatetime == ~N[2010-04-17 14:00:00.000000]
      assert order.table_id == 42
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Report.create_order(@invalid_attrs)
    end

    test "update_order/2 with valid data updates the order" do
      order = order_fixture()
      assert {:ok, order} = Report.update_order(order, @update_attrs)
      assert %Order{} = order
      assert order.items == "some updated items"
      assert order.order_id == 43
      assert order.organization_id == 43
      assert order.rest_id == 43
      assert order.salesdate == ~D[2011-05-18]
      assert order.salesdatetime == ~N[2011-05-18 15:01:01.000000]
      assert order.table_id == 43
    end

    test "update_order/2 with invalid data returns error changeset" do
      order = order_fixture()
      assert {:error, %Ecto.Changeset{}} = Report.update_order(order, @invalid_attrs)
      assert order == Report.get_order!(order.id)
    end

    test "delete_order/1 deletes the order" do
      order = order_fixture()
      assert {:ok, %Order{}} = Report.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> Report.get_order!(order.id) end
    end

    test "change_order/1 returns a order changeset" do
      order = order_fixture()
      assert %Ecto.Changeset{} = Report.change_order(order)
    end
  end
end
