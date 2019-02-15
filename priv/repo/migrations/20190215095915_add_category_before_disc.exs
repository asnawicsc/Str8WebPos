defmodule Webpos.Repo.Migrations.AddCategoryBeforeDisc do
  use Ecto.Migration

  def change do
    alter table("sales_details") do
      add(:category, :string)
    end

    alter table("sales") do
      add(:before_discount_sub_total, :decimal)
    end
  end
end
