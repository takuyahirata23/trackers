defmodule Trackers.Laps do
  @moduledoc """
  The Laps context.
  """

  alias Trackers.Laps.FastLap
  alias Trackers.Helpers.Time

  import Ecto.Query, warn: false
  alias Trackers.Repo

  def insert_fast_lap_a_day(attrs) do
    %FastLap{}
    |> FastLap.changeset(attrs)
    |> Repo.insert()
  end

  def list_fast_laps_for_layout(layout_id) when is_binary(layout_id) do
    Repo.all(
      from f in FastLap,
        where: f.layout_id == ^layout_id,
        select: %{f | lap_time: ^Time.convert_milliseconds_to_lap_time(f.lap_time)}
    )
  end
end
