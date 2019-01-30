defmodule Webpos.Repo.Migrations.AddTaxPercServ do
  use Ecto.Migration

  def change do
    alter table("restaurants") do
      add(:tax_perc, :decimal)
      add(:serv, :decimal)
    end
  end
end
