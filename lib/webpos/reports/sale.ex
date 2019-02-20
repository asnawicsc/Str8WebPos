defmodule Webpos.Reports.Sale do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sales" do
    field(:discount_description, :string)
    field(:discount_name, :string)
    field(:discounted_amount, :decimal)
    field(:grand_total, :decimal)
    field(:invoiceno, :integer)
    field(:pax, :integer)
    field(:rounding, :decimal)
    field(:salesdate, :date)
    field(:salesdatetime, :naive_datetime)
    field(:salesid, :string)
    field(:service_charge, :decimal)
    field(:staffid, :string)
    field(:sub_total, :decimal)
    field(:tax, :decimal)
    field(:tbl_no, :string)
    field(:transaction_type, :string)
    field(:organization_id, :integer)
    field(:rest_name, :string)
    timestamps()
  end

  @doc false
  def changeset(sale, attrs) do
    sale
    |> cast(attrs, [
      :rest_name,
      :organization_id,
      :salesid,
      :pax,
      :tbl_no,
      :sub_total,
      :tax,
      :service_charge,
      :rounding,
      :grand_total,
      :salesdate,
      :salesdatetime,
      :invoiceno,
      :staffid,
      :transaction_type,
      :discount_name,
      :discounted_amount,
      :discount_description
    ])
    |> validate_required([
      :salesid,
      :pax,
      :tbl_no,
      :sub_total,
      :tax,
      :service_charge,
      :rounding,
      :grand_total,
      :salesdate,
      :salesdatetime,
      :invoiceno,
      :staffid,
      :transaction_type,
      :discount_name,
      :discounted_amount,
      :discount_description
    ])
  end
end

defmodule Webpos.Reports.SalesDetail do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sales_details" do
    field(:salesid, :string)
    field(:order_id, :string)
    field(:table_id, :string)
    field(:itemname, :string)
    field(:unit_price, :decimal)
    field(:qty, :integer)
    field(:sub_total, :decimal)
    timestamps()
  end

  @doc false
  def changeset(sales_details, attrs) do
    sales_details
    |> cast(attrs, [
      :salesid,
      :order_id,
      :table_id,
      :itemname,
      :unit_price,
      :qty,
      :sub_total
    ])
    |> validate_required([
      :salesid
    ])
  end
end

defmodule Webpos.Reports.SalesPayment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sales_payments" do
    field(:salesid, :string)
    field(:order_id, :string)
    field(:payment_type, :string)
    field(:sub_total, :decimal)
    field(:gst_charge, :decimal)
    field(:service_charge, :decimal)
    field(:rounding, :decimal)
    field(:grand_total, :decimal)
    field(:cash, :decimal)
    field(:changes, :decimal)
    field(:salesdate, :string)
    field(:salesdatetime, :string)
    field(:remarks, :string)
    timestamps()
  end

  @doc false
  def changeset(sales_payment, attrs) do
    sales_payment
    |> cast(attrs, [
      :remarks,
      :salesid,
      :order_id,
      :payment_type,
      :sub_total,
      :gst_charge,
      :service_charge,
      :rounding,
      :grand_total,
      :cash,
      :changes,
      :salesdate,
      :salesdatetime
    ])
    |> validate_required([
      :salesid
    ])
  end
end
