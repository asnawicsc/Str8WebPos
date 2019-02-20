defmodule Webpos.Repo.Migrations.DropAddInvoiceNo do
  use Ecto.Migration

  def change do
    alter table("sales") do
      remove(:invoiceno)
      add(:invoiceno, :integer)
    end
  end
end
