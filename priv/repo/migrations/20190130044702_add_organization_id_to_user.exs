defmodule Webpos.Repo.Migrations.AddOrganizationIdToUser do
  use Ecto.Migration

  def change do
    alter table("users") do
      add(:organization_id, :integer)
    end
  end
end
