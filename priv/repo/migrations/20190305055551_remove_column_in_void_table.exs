defmodule Webpos.Repo.Migrations.RemoveColumnInVoidTable do
  use Ecto.Migration

  def change do
    alter table("void_items") do
      remove(:rest_id)

      add(:rest_id, :integer)
    end
  end
end
