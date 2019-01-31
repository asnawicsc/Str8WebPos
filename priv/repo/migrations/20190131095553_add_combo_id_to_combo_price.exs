defmodule Webpos.Repo.Migrations.AddComboIdToComboPrice do
  use Ecto.Migration

  def change do
    alter table("combo_price") do
      add(:combo_id, :integer)
    end
  end
end
