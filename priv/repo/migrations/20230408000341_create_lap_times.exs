defmodule Trackers.Repo.Migrations.CreateLapTimes do
  use Ecto.Migration

  def change do
    create table(:fast_lap, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :lap_time, :integer, null: false
      add :date, :date, null: false
      add :layout_id, references(:layouts, type: :binary_id, on_delete: :delete_all, null: false)
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all, null: false)

      add :motorcycle_id,
          references(:motorcycles, type: :binary_id, on_delete: :delete_all, null: false)

      timestamps()
    end

    create(index(:fast_lap, [:layout_id]))
    create(index(:fast_lap, [:user_id]))
    create(unique_index(:fast_lap, [:user_id, :date, :motorcycle_id, :layout_id]))
  end
end
