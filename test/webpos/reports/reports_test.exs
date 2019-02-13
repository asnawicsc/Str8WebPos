defmodule Webpos.ReportsTest do
  use Webpos.DataCase

  alias Webpos.Reports

  describe "sales" do
    alias Webpos.Reports.Sale

    @valid_attrs %{discount_description: "some discount_description", discount_name: "some discount_name", discounted_amount: "120.5", grand_total: "120.5", invoiceno: "some invoiceno", pax: 42, rounding: "120.5", salesdate: ~D[2010-04-17], salesdatetime: ~N[2010-04-17 14:00:00.000000], salesid: "some salesid", service_charge: "120.5", staffid: "some staffid", sub_total: "120.5", tax: "120.5", tbl_no: "some tbl_no", transaction_type: "some transaction_type"}
    @update_attrs %{discount_description: "some updated discount_description", discount_name: "some updated discount_name", discounted_amount: "456.7", grand_total: "456.7", invoiceno: "some updated invoiceno", pax: 43, rounding: "456.7", salesdate: ~D[2011-05-18], salesdatetime: ~N[2011-05-18 15:01:01.000000], salesid: "some updated salesid", service_charge: "456.7", staffid: "some updated staffid", sub_total: "456.7", tax: "456.7", tbl_no: "some updated tbl_no", transaction_type: "some updated transaction_type"}
    @invalid_attrs %{discount_description: nil, discount_name: nil, discounted_amount: nil, grand_total: nil, invoiceno: nil, pax: nil, rounding: nil, salesdate: nil, salesdatetime: nil, salesid: nil, service_charge: nil, staffid: nil, sub_total: nil, tax: nil, tbl_no: nil, transaction_type: nil}

    def sale_fixture(attrs \\ %{}) do
      {:ok, sale} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Reports.create_sale()

      sale
    end

    test "list_sales/0 returns all sales" do
      sale = sale_fixture()
      assert Reports.list_sales() == [sale]
    end

    test "get_sale!/1 returns the sale with given id" do
      sale = sale_fixture()
      assert Reports.get_sale!(sale.id) == sale
    end

    test "create_sale/1 with valid data creates a sale" do
      assert {:ok, %Sale{} = sale} = Reports.create_sale(@valid_attrs)
      assert sale.discount_description == "some discount_description"
      assert sale.discount_name == "some discount_name"
      assert sale.discounted_amount == Decimal.new("120.5")
      assert sale.grand_total == Decimal.new("120.5")
      assert sale.invoiceno == "some invoiceno"
      assert sale.pax == 42
      assert sale.rounding == Decimal.new("120.5")
      assert sale.salesdate == ~D[2010-04-17]
      assert sale.salesdatetime == ~N[2010-04-17 14:00:00.000000]
      assert sale.salesid == "some salesid"
      assert sale.service_charge == Decimal.new("120.5")
      assert sale.staffid == "some staffid"
      assert sale.sub_total == Decimal.new("120.5")
      assert sale.tax == Decimal.new("120.5")
      assert sale.tbl_no == "some tbl_no"
      assert sale.transaction_type == "some transaction_type"
    end

    test "create_sale/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Reports.create_sale(@invalid_attrs)
    end

    test "update_sale/2 with valid data updates the sale" do
      sale = sale_fixture()
      assert {:ok, sale} = Reports.update_sale(sale, @update_attrs)
      assert %Sale{} = sale
      assert sale.discount_description == "some updated discount_description"
      assert sale.discount_name == "some updated discount_name"
      assert sale.discounted_amount == Decimal.new("456.7")
      assert sale.grand_total == Decimal.new("456.7")
      assert sale.invoiceno == "some updated invoiceno"
      assert sale.pax == 43
      assert sale.rounding == Decimal.new("456.7")
      assert sale.salesdate == ~D[2011-05-18]
      assert sale.salesdatetime == ~N[2011-05-18 15:01:01.000000]
      assert sale.salesid == "some updated salesid"
      assert sale.service_charge == Decimal.new("456.7")
      assert sale.staffid == "some updated staffid"
      assert sale.sub_total == Decimal.new("456.7")
      assert sale.tax == Decimal.new("456.7")
      assert sale.tbl_no == "some updated tbl_no"
      assert sale.transaction_type == "some updated transaction_type"
    end

    test "update_sale/2 with invalid data returns error changeset" do
      sale = sale_fixture()
      assert {:error, %Ecto.Changeset{}} = Reports.update_sale(sale, @invalid_attrs)
      assert sale == Reports.get_sale!(sale.id)
    end

    test "delete_sale/1 deletes the sale" do
      sale = sale_fixture()
      assert {:ok, %Sale{}} = Reports.delete_sale(sale)
      assert_raise Ecto.NoResultsError, fn -> Reports.get_sale!(sale.id) end
    end

    test "change_sale/1 returns a sale changeset" do
      sale = sale_fixture()
      assert %Ecto.Changeset{} = Reports.change_sale(sale)
    end
  end
end
