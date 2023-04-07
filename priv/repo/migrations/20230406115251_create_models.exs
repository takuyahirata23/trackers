defmodule Trackers.Repo.Migrations.CreateModels do
  use Ecto.Migration

  def change do
    create table(:models, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :citext, null: false
      add :make_id, references(:makes, type: :binary_id, on_delete: :delete_all, null: false)

      timestamps()
    end

    create(index(:models, [:make_id]))
    create(unique_index(:models, [:name, :make_id]))
  end
end
