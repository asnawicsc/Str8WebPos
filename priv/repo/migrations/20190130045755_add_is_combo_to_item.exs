defmodule Webpos.Repo.Migrations.AddIsComboToItem do
  use Ecto.Migration

  def change do
    alter table("items") do
      add(:is_combo, :boolean)
    end
  end
end
