defmodule Webpos.Repo.Migrations.ChangeDataTypeModalLog do
  use Ecto.Migration

 def change do
    alter table("modallogs") do
      remove(:after_change)
      remove(:before_change)
      add(:after_change, :text)
      add(:before_change, :text)
    end

  end
end
