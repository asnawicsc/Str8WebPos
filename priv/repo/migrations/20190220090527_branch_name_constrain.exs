defmodule Webpos.Repo.Migrations.BranchNameConstrain do
  use Ecto.Migration

  def change do
    create(unique_index(:restaurants, [:code, :organization_id], name: :org_rest_code))
  end
end
