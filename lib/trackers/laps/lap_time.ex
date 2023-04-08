defmodule Trackers.Laps.LapTime do
  use Ecto.Schema
  import Ecto.Changeset
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "lap_times" do
    field :lap_time, :integer
    field :date, :date

    belongs_to :user, Trackers.Accounts.User
    belongs_to :motorcycle, Trackers.Motorcycles.Motorcycle
    belongs_to :layout, Trackers.Tracks.Layout

    timestamps()
  end

  def changeset(lap_time, attrs \\ %{}) do
    lap_time
    |> cast(attrs, [:lap_time, :date, :user_id, :motorcycle_id, :layout_id])
    |> validate_required([:lap_time, :date, :user_id, :motorcycle_id, :layout_id])
    |> validate_number(:lap_time, less_than_or_equals_to: 300_000)
  end
end
