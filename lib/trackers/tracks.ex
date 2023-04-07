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

  def list_tracks_for_select do
    Repo.all(from t in Track, select: {t.name, t.id}, order_by: t.name)
  end

  def register_layout(attrs) do
    %Layout{}
    |> Layout.changeset(attrs)
    |> Repo.insert()
  end

  def list_registered_tracks do
    Repo.all(from t in Track, preload: [:layouts], order_by: [t.name])
  end
end
