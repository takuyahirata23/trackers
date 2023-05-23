defmodule Trackers.Repo.Migrations.CreateTrackdays do
  use Ecto.Migration

  def change do
    create table(:trackdays, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :best_lap, :integer
      add :average_lap, :integer
      add :date, :date, null: false
      add :note, :string

      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all, null: false)

      add :motorcycle_id,
          references(:motorcycles, type: :binary_id, on_delete: :delete_all, null: false)

      add :layout_id, references(:layouts, type: :binary_id, on_delete: :delete_all, null: false)

      timestamps()
    end

    create(index(:trackdays, [:user_id]))
    create(unique_index(:trackdays, [:user_id, :date]))
  end
end
