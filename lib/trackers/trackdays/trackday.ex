defmodule Trackers.Trackdays.Trackday do
  use Ecto.Schema

  import Ecto.Changeset
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  alias Trackers.Accounts.User
  alias Trackers.Motorcycles.Motorcycle
  alias Trackers.Tracks.Layout

  schema "trackdays" do
    field :best_lap, :integer
    field :average_lap, :integer
    field :date, :date
    field :note, :string

    belongs_to :user, User
    belongs_to :motorcycle, Motorcycle
    belongs_to :layout, Layout

    timestamps()
  end

  def changeset(trackday, attrs \\ %{}) do
    trackday
    |> cast(attrs, [:best_lap, :average_lap, :date, :note, :user_id, :motorcycle_id, :layout_id])
    |> validate_required([:date, :user_id, :motorcycle_id, :layout_id])
    |> validate_number(:best_lap, less_than_or_equal_to: 300_000)
    |> validate_number(:average_lap, less_than_or_equal_to: 300_000)
    |> unique_constraint([:user_id, :date])
  end
end
