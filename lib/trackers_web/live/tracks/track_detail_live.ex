defmodule TrackersWeb.TrackDetailLive do
  use TrackersWeb, :live_view

  alias Trackers.Tracks
  alias TrackersWeb.Card

  def render(assigns) do
    ~H"""
    <h2 class="font-bold text-xl"><%= "#{@track.name}" %></h2>
    <p :if={@track.description} class="mt-4"><%= "#{@track.description}" %></p>
    <ul class="mt-8 flex flex-col gap-y-8">
      <li :for={layout <- @layouts}>
        <.link navigate={~p"/tracks/#{@track.id}/#{layout.id}"}>
          <Card.primary>
            <h3><%= "#{layout.name}" %></h3>
          </Card.primary>
        </.link>
      </li>
    </ul>
    """
  end

  def mount(%{"id" => track_id}, _session, socket) do
    track = Tracks.get_registered_track(track_id)
    layouts = Tracks.get_layouts_by_track_id(track_id)

    {:ok, assign(socket, track: track, layouts: layouts, target_id: nil)}
  end
end
