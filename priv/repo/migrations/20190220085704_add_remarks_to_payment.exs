defmodule Webpos.Repo.Migrations.AddRemarksToPayment do
  use Ecto.Migration

  def change do
    alter table("sales_payments") do
      add(:remarks, :string)
    end
  end
end
