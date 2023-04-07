defmodule Trackers.Tracks do
  @moduledoc """
  The Tracks context.
  """

  import Ecto.Query, warn: false

  alias Trackers.Repo
  alias Trackers.Tracks.{Track, Layout}

  def register_track(attrs) do
    %Track{}
    |> Track.changeset(attrs)
    |> Repo.insert()
  end

  def register_track_layout(attrs) do
    %Layout{}
    |> Track.changeset(attrs)
    |> Repo.insert()
  end
end
