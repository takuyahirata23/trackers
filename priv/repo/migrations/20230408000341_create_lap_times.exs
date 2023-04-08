defmodule Trackers.Repo.Migrations.CreateLapTimes do
  use Ecto.Migration

  def change do
    create table(:lap_times, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :lap_time, :integer, null: false
      add :date, :date, null: false
      add :layout_id, references(:layouts, type: :binary_id, on_delete: :delete_all, null: false)
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all, null: false)

      add :motorcycle_id,
          references(:motorcycles, type: :binary_id, on_delete: :delete_all, null: false)

      timestamps()
    end

    create(index(:lap_times, [:layout_id]))
    create(index(:lap_times, [:user_id]))
  end
end
