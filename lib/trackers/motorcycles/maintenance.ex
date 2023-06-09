defmodule Trackers.Motorcycles.Maintenance do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  alias Trackers.Motorcycles.Motorcycle
  alias Trackers.Accounts.User

  schema "maintenances" do
    field :title, :string
    field :date, :date
    field :note, :string
    field :odometer, :integer

    belongs_to :motorcycle, Motorcycle
    belongs_to :user, User

    timestamps()
  end

  def changeset(maintenance, attrs \\ %{}) do
    maintenance
    |> cast(attrs, [:title, :date, :odometer, :note, :user_id, :motorcycle_id])
    |> validate_required([:title, :date, :user_id, :motorcycle_id])
  end
end
