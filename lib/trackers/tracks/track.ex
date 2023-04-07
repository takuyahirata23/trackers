defmodule Trackers.Tracks.Track do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "tracks" do
    field :name, :string
    field :description, :string

    has_many :layouts, Trackers.Tracks.Layout

    timestamps()
  end

  def changeset(track, attrs \\ %{}) do
    track
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
    |> validate_length(:name, min: 2, max: 50)
    |> validate_length(:description, max: 200)
  end
end
