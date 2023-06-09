defmodule Trackers.Repo.Migrations.CreateMaintenance do
  use Ecto.Migration

  def change do
    create table(:maintenances, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string, null: false
      add :date, :date, null: false
      add :odometer, :integer
      add :note, :string

      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all, null: false)

      add :motorcycle_id,
          references(:motorcycles, type: :binary_id, on_delete: :delete_all, null: false)

      timestamps()
    end

    create(index(:maintenances, [:user_id]))
    create(index(:maintenances, [:motorcycle_id]))
  end
end
