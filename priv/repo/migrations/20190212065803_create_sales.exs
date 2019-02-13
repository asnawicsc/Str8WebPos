defmodule Webpos.Repo.Migrations.CreateSales do
  use Ecto.Migration

  def change do
    create table(:sales) do
      add :salesid, :string
      add :pax, :integer
      add :tbl_no, :string
      add :sub_total, :decimal
      add :tax, :decimal
      add :service_charge, :decimal
      add :rounding, :decimal
      add :grand_total, :decimal
      add :salesdate, :date
      add :salesdatetime, :naive_datetime
      add :invoiceno, :string
      add :staffid, :string
      add :transaction_type, :string
      add :discount_name, :string
      add :discounted_amount, :decimal
      add :discount_description, :string

      timestamps()
    end

  end
end
