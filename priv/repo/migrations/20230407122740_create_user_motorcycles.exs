defmodule Trackers.Repo.Migrations.CreateUserMotorcycles do
  use Ecto.Migration

  def change do
    create table(:motorcycles, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :year, :integer, null: false

      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all, null: false)
      add :make_id, references(:makes, type: :binary_id, on_delete: :delete_all, null: false)
      add :model_id, references(:models, type: :binary_id, on_delete: :delete_all, null: false)

      timestamps()
    end

    create(index(:motorcycles, [:user_id]))
    create(unique_index(:motorcycles, [:user_id, :make_id, :model_id, :year]))
  end
end
