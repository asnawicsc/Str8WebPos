defmodule Webpos.Repo.Migrations.ChangeDataTypeModalLog2 do
  use Ecto.Migration

  def change do
 alter table("modallogs") do
     
      add(:changes, :text)
    end
  end
end
