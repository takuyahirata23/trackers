defmodule Trackers.Laps do
  @moduledoc """
  The Laps context.
  """

  alias Trackers.Laps.LapTime

  import Ecto.Query, warn: false
  alias Trackers.Repo

  def insert_lap_time(attrs) do
    %LapTime{}
    |> LapTime.changeset(attrs)
    |> Repo.insert()
  end
end
