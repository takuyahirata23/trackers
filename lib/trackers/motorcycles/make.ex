defmodule Trackers.Motorcycles.Make do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "makes" do
    field :name, :string

    timestamps()
  end

  def changeset(makes, attrs \\ %{}) do
    makes
    |> cast(attrs, [:name])
    |> validate_length(:name, min: 2, max: 30)
    |> unique_constraint(:name, message: "#{attrs["name"]} already exists")
  end
end
