defmodule Trackers.Motorcycles.Motorcycle do
  use Ecto.Schema
  import Ecto.Changeset

  alias Trackers.Accounts.User
  alias Trackers.Motorcycles.{Make, Model}
  alias Trackers.Laps.FastLap

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "motorcycles" do
    field :year, :integer

    belongs_to :user, User
    belongs_to :make, Make
    belongs_to :model, Model

    has_many :lap_times, FastLap

    timestamps()
  end

  def changeset(motorcycle, attrs \\ %{}) do
    motorcycle
    |> cast(attrs, [:year, :user_id, :make_id, :model_id])
    |> validate_required([:year, :user_id, :make_id, :model_id])
    |> validate_number(:year,
      greater_than: 1800,
      less_than_or_equal_to: DateTime.utc_now() |> Map.fetch!(:year)
    )
    |> unique_constraint([:user_id, :make_id, :model_id, :year],
      message: "You have already registered this motorcycle"
    )
  end
end
