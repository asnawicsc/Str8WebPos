defmodule Webpos.Repo.Migrations.AddOrgIdToRest do
  use Ecto.Migration

  def change do
    alter table("restaurants") do
      add(:organization_id, :integer)
    end
  end
end
