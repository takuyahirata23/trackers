defmodule TrackersWeb.LayoutLive do
  use TrackersWeb, :live_view

  alias Trackers.Tracks

  def render(assigns) do
    ~H"""
    <h2 class="font-bold text-xl"><%= "#{@track_layout.name}" %></h2>
    <p :if={@track_layout.description} class="mt-4"><%= "#{@track_layout.description}" %></p>
    """
  end

  def mount(%{"layout_id" => layout_id}, _session, socket) do
    track_layout = Tracks.get_layout_by_id(layout_id)

    {:ok,
     assign(socket,
       track_layout: track_layout,
       layout_id: layout_id,
       layout_id: layout_id
     )}
  end
end
