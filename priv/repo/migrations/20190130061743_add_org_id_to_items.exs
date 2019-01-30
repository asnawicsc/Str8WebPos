defmodule Webpos.Repo.Migrations.AddOrgIdToItems do
  use Ecto.Migration

  def change do
    alter table("items") do
      add(:organization_id, :integer)
    end
  end
end
