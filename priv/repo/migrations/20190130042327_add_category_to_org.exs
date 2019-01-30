defmodule Webpos.Repo.Migrations.AddCategoryToOrg do
  use Ecto.Migration

  def change do
    alter table("organizations") do
      add(:categories, :string)
      add(:payments, :string)
    end
  end
end
