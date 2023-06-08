defmodule TrackersWeb.UserDashboardLive do
  use TrackersWeb, :live_view

  alias Trackers.Trackdays
  alias TrackersWeb.Card

  def render(assigns) do
    ~H"""
    <div>
      <Card.primary :if={!Enum.empty?(@latest_trackdays)} title="Latest Trackdays">
        <ul class="flex flex-col gap-y-4">
          <li :for={trackday <- @latest_trackdays}>
            <.link navigate={~p"/users/trackdays/#{trackday.id}"} class="flex gap-y-2 justify-between">
              <span><%= trackday.track_name %></span>
              <span><%= trackday.date %></span>
            </.link>
          </li>
        </ul>
      </Card.primary>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    user_id = socket.assigns.current_user.id
    latest_trackdays = Trackdays.list_latest_trackdays(user_id)

    {:ok, assign(socket, latest_trackdays: latest_trackdays)}
  end
end
