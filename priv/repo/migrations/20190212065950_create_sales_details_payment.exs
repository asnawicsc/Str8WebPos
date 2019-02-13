defmodule Webpos.Repo.Migrations.CreateSalesDetailsPayment do
  use Ecto.Migration

  def change do
    create(index("sales", [:salesid]))

    create table(:sales_details) do
      add(:salesid, :string)
      add(:order_id, :string)
      add(:table_id, :string)
      add(:itemname, :string)
      add(:unit_price, :decimal)
      add(:qty, :integer)
      add(:sub_total, :decimal)

      timestamps()
    end

    create(index("sales_details", [:salesid]))

    create table(:sales_payments) do
      add(:salesid, :string)
      add(:order_id, :string)
      add(:payment_type, :string)
      add(:sub_total, :decimal)
      add(:gst_charge, :decimal)
      add(:service_charge, :decimal)
      add(:rounding, :decimal)
      add(:grand_total, :decimal)
      add(:cash, :decimal)
      add(:changes, :decimal)
      add(:salesdate, :string)
      add(:salesdatetime, :string)

      timestamps()
    end

    create(index("sales_payments", [:salesid]))
  end
end
