defmodule Webpos.Repo.Migrations.AddOrgIdToSales do
  use Ecto.Migration

  def change do
    alter table("sales") do
      add(:organization_id, :integer)
      add(:rest_name, :string)
    end

    create(index("sales", [:organization_id]))
    create(index("sales", [:salesdate]))
    create(index("sales", [:rest_name]))
  end
end
