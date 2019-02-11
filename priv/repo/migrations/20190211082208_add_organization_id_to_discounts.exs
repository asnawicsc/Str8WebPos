defmodule Webpos.Repo.Migrations.AddOrganizationIdToDiscounts do
  use Ecto.Migration

  def change do
    alter table("discounts") do
      add(:organization_id, :integer)
    end
  end
end
