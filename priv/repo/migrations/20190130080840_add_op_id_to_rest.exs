defmodule Webpos.Repo.Migrations.AddOpIdToRest do
  use Ecto.Migration

  def change do
    alter table("restaurants") do
      add(:op_id, :integer)
    end
  end
end
