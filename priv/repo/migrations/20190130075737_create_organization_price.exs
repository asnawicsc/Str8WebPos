defmodule Webpos.Repo.Migrations.CreateOrganizationPrice do
  use Ecto.Migration

  def change do
    create table(:organization_price) do
      add :organization_id, :integer
      add :name, :string

      timestamps()
    end

  end
end
