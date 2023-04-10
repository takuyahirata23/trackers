defmodule TrackersWeb.TracksLive do
  use TrackersWeb, :live_view

  alias Trackers.Tracks
  alias TrackersWeb.Card

  def render(assigns) do
    ~H"""
    <h2 class="font-bold text-xl">Tracks</h2>
    <ul class="flex flex-col gap-y-8 mt-8">
      <li :for={track <- @tracks}>
        <Card.primary title={"#{track.name}"}>
          <.link navigate={~p"/tracks/#{track.id}"}>
            <ul class="flex flex-col">
              <li :for={layout <- track.layouts}>
                <p><%= "#{layout.name}" %></p>
              </li>
            </ul>
          </.link>
        </Card.primary>
      </li>
    </ul>
    """
  end

  def mount(_params, _session, socket) do
    tracks = Tracks.list_registered_tracks()
    {:ok, assign(socket, tracks: tracks)}
  end
end
