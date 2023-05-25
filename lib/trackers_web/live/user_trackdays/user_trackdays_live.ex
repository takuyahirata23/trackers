defmodule TrackersWeb.UserTrackdaysLive do
  use TrackersWeb, :live_view

  alias Trackers.Trackdays
  alias TrackersWeb.Card

  def render(assigns) do
    ~H"""
    <div>
      <h2 class="font-bold text-xl">Trackdays</h2>
      <ul :for={trackday <- @trackdays}>
        <li>
          <Card.primary>
            <.link navigate={~p"/users/trackdays/#{trackday.id}"} class="flex justify-between">
              <span>
                <%= "#{trackday.layout.name}" %>
              </span>
              <span>
                <%= "#{trackday.date}" %>
              </span>
            </.link>
          </Card.primary>
        </li>
      </ul>
    </div>
    """
  end

  def mount(_parms, _session, socket) do
    trackdays = Trackdays.list_all_trackdays(socket.assigns.current_user.id)

    {:ok,
     assign(socket,
       trackdays: trackdays
     )}
  end
end
