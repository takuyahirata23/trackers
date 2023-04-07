defmodule Trackers.Motorcycles.Model do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "models" do
    field :name, :string

    belongs_to :make, Trackers.Motorcycles.Make

    timestamps()
  end

  def changeset(model, attrs \\ %{}) do
    model
    |> cast(attrs, [:name, :make_id])
    |> validate_required([:name, :make_id])
    |> validate_length(:name, min: 2, max: 30)
    |> unique_constraint([:name, :make_id])
  end
end
