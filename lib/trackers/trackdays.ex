defmodule Trackers.Trackdays do
  @moduledoc """
  The Trackdays context.
  """

  alias Trackers.Trackdays.Trackday

  import Ecto.Query, warn: false
  alias Trackers.Repo

  def save_trackday(attrs) do
    %Trackday{}
    |> Trackday.changeset(attrs)
    |> Repo.insert()
  end

  def get_trackday_by_id(id) when is_binary(id) do
    Repo.get_by(Trackday, id: id)
    |> Repo.preload(layout: :track, motorcycle: :make, motorcycle: :model)
  end

  def list_all_trackdays(user_id) when is_binary(user_id) do
    Repo.all(from t in Trackday, where: t.user_id == ^user_id, preload: [:layout])
  end
end
