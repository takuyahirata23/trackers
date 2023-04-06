defmodule Trackers.Repo.Migrations.CreateMakes do
  use Ecto.Migration

  def change do
    create table(:makes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :citext, null: false

      timestamps()
    end

    create(unique_index(:makes, [:name]))
  end
end
