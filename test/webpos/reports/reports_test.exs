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

  describe "shifts" do
    alias Webpos.Reports.Shift

    @valid_attrs %{close_amount: "120.5", closing_staff: "some closing_staff", end_datetime: ~N[2010-04-17 14:00:00.000000], open_amount: "120.5", opening_staff: "some opening_staff", organization_id: 42, rest_id: 42, start_datetime: ~N[2010-04-17 14:00:00.000000]}
    @update_attrs %{close_amount: "456.7", closing_staff: "some updated closing_staff", end_datetime: ~N[2011-05-18 15:01:01.000000], open_amount: "456.7", opening_staff: "some updated opening_staff", organization_id: 43, rest_id: 43, start_datetime: ~N[2011-05-18 15:01:01.000000]}
    @invalid_attrs %{close_amount: nil, closing_staff: nil, end_datetime: nil, open_amount: nil, opening_staff: nil, organization_id: nil, rest_id: nil, start_datetime: nil}

    def shift_fixture(attrs \\ %{}) do
      {:ok, shift} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Reports.create_shift()

      shift
    end

    test "list_shifts/0 returns all shifts" do
      shift = shift_fixture()
      assert Reports.list_shifts() == [shift]
    end

    test "get_shift!/1 returns the shift with given id" do
      shift = shift_fixture()
      assert Reports.get_shift!(shift.id) == shift
    end

    test "create_shift/1 with valid data creates a shift" do
      assert {:ok, %Shift{} = shift} = Reports.create_shift(@valid_attrs)
      assert shift.close_amount == Decimal.new("120.5")
      assert shift.closing_staff == "some closing_staff"
      assert shift.end_datetime == ~N[2010-04-17 14:00:00.000000]
      assert shift.open_amount == Decimal.new("120.5")
      assert shift.opening_staff == "some opening_staff"
      assert shift.organization_id == 42
      assert shift.rest_id == 42
      assert shift.start_datetime == ~N[2010-04-17 14:00:00.000000]
    end

    test "create_shift/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Reports.create_shift(@invalid_attrs)
    end

    test "update_shift/2 with valid data updates the shift" do
      shift = shift_fixture()
      assert {:ok, shift} = Reports.update_shift(shift, @update_attrs)
      assert %Shift{} = shift
      assert shift.close_amount == Decimal.new("456.7")
      assert shift.closing_staff == "some updated closing_staff"
      assert shift.end_datetime == ~N[2011-05-18 15:01:01.000000]
      assert shift.open_amount == Decimal.new("456.7")
      assert shift.opening_staff == "some updated opening_staff"
      assert shift.organization_id == 43
      assert shift.rest_id == 43
      assert shift.start_datetime == ~N[2011-05-18 15:01:01.000000]
    end

    test "update_shift/2 with invalid data returns error changeset" do
      shift = shift_fixture()
      assert {:error, %Ecto.Changeset{}} = Reports.update_shift(shift, @invalid_attrs)
      assert shift == Reports.get_shift!(shift.id)
    end

    test "delete_shift/1 deletes the shift" do
      shift = shift_fixture()
      assert {:ok, %Shift{}} = Reports.delete_shift(shift)
      assert_raise Ecto.NoResultsError, fn -> Reports.get_shift!(shift.id) end
    end

    test "change_shift/1 returns a shift changeset" do
      shift = shift_fixture()
      assert %Ecto.Changeset{} = Reports.change_shift(shift)
    end
  end

  describe "modallogs" do
    alias Webpos.Reports.ModalLllog

    @valid_attrs %{after_change: "some after_change", before_change: "some before_change", category: "some category", datetime: ~N[2010-04-17 14:00:00.000000], primary_id: 42, user_name: "some user_name", user_type: "some user_type"}
    @update_attrs %{after_change: "some updated after_change", before_change: "some updated before_change", category: "some updated category", datetime: ~N[2011-05-18 15:01:01.000000], primary_id: 43, user_name: "some updated user_name", user_type: "some updated user_type"}
    @invalid_attrs %{after_change: nil, before_change: nil, category: nil, datetime: nil, primary_id: nil, user_name: nil, user_type: nil}

    def modal_lllog_fixture(attrs \\ %{}) do
      {:ok, modal_lllog} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Reports.create_modal_lllog()

      modal_lllog
    end

    test "list_modallogs/0 returns all modallogs" do
      modal_lllog = modal_lllog_fixture()
      assert Reports.list_modallogs() == [modal_lllog]
    end

    test "get_modal_lllog!/1 returns the modal_lllog with given id" do
      modal_lllog = modal_lllog_fixture()
      assert Reports.get_modal_lllog!(modal_lllog.id) == modal_lllog
    end

    test "create_modal_lllog/1 with valid data creates a modal_lllog" do
      assert {:ok, %ModalLllog{} = modal_lllog} = Reports.create_modal_lllog(@valid_attrs)
      assert modal_lllog.after_change == "some after_change"
      assert modal_lllog.before_change == "some before_change"
      assert modal_lllog.category == "some category"
      assert modal_lllog.datetime == ~N[2010-04-17 14:00:00.000000]
      assert modal_lllog.primary_id == 42
      assert modal_lllog.user_name == "some user_name"
      assert modal_lllog.user_type == "some user_type"
    end

    test "create_modal_lllog/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Reports.create_modal_lllog(@invalid_attrs)
    end

    test "update_modal_lllog/2 with valid data updates the modal_lllog" do
      modal_lllog = modal_lllog_fixture()
      assert {:ok, modal_lllog} = Reports.update_modal_lllog(modal_lllog, @update_attrs)
      assert %ModalLllog{} = modal_lllog
      assert modal_lllog.after_change == "some updated after_change"
      assert modal_lllog.before_change == "some updated before_change"
      assert modal_lllog.category == "some updated category"
      assert modal_lllog.datetime == ~N[2011-05-18 15:01:01.000000]
      assert modal_lllog.primary_id == 43
      assert modal_lllog.user_name == "some updated user_name"
      assert modal_lllog.user_type == "some updated user_type"
    end

    test "update_modal_lllog/2 with invalid data returns error changeset" do
      modal_lllog = modal_lllog_fixture()
      assert {:error, %Ecto.Changeset{}} = Reports.update_modal_lllog(modal_lllog, @invalid_attrs)
      assert modal_lllog == Reports.get_modal_lllog!(modal_lllog.id)
    end

    test "delete_modal_lllog/1 deletes the modal_lllog" do
      modal_lllog = modal_lllog_fixture()
      assert {:ok, %ModalLllog{}} = Reports.delete_modal_lllog(modal_lllog)
      assert_raise Ecto.NoResultsError, fn -> Reports.get_modal_lllog!(modal_lllog.id) end
    end

    test "change_modal_lllog/1 returns a modal_lllog changeset" do
      modal_lllog = modal_lllog_fixture()
      assert %Ecto.Changeset{} = Reports.change_modal_lllog(modal_lllog)
    end
  end
end
