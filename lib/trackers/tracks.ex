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

  def list_layouts_for_select do
    Repo.all(from t in Layout, select: {t.name, t.id}, order_by: t.name)
  end

  def register_layout(attrs) do
    %Layout{}
    |> Layout.changeset(attrs)
    |> Repo.insert()
  end

  def list_registered_tracks do
    Repo.all(from t in Track, preload: [:layouts], order_by: [t.name])
  end

  def get_registered_track(track_id) when is_binary(track_id) do
    Repo.get_by(Track, id: track_id)
  end

  def get_layouts_by_track_id(track_id) when is_binary(track_id) do
    Repo.all(from l in Layout, where: l.track_id == ^track_id)
  end

  # def get_layouts_by_track_id(track_id) when is_binary(track_id) do
  #   Repo.all(from l in Layout, where: l.track_id == ^track_id, preload: [:fast_laps])
  # end

  def get_layout_by_id(id) when is_binary(id) do
    Repo.one(from l in Layout, where: l.id == ^id)
  end
end
