defmodule Webpos.Repo.Migrations.ChangeDataTypeModalLog4 do
  use Ecto.Migration

  def change do
 alter table("modallogs") do
     
      add(:organization_id, :integer)
    end
  end
end
