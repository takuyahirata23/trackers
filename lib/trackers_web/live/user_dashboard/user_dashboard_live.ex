defmodule TrackersWeb.UserDashboardLive do
  use TrackersWeb, :live_view

  alias Trackers.Trackdays
  alias TrackersWeb.Card
  alias Trackers.Helpers.Time

  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-y-10">
      <Card.primary :if={!Enum.empty?(@latest_trackdays)} title="Latest Trackdays">
        <ul class="flex flex-col gap-y-8">
          <li :for={trackday <- @latest_trackdays}>
            <.link navigate={~p"/users/trackdays/#{trackday.id}"} class="flex gap-y-2 justify-between">
              <span><%= trackday.track_name %></span>
              <span class="text-sm"><%= trackday.date %></span>
            </.link>
          </li>
        </ul>
      </Card.primary>
      <Card.primary :if={!Enum.empty?(@best_laps)} title="Best Laps">
        <ul class="flex flex-col gap-y-8">
          <li :for={best_lap <- @best_laps}>
            <.link
              navigate={~p"/users/trackdays/#{best_lap.trackday_id}"}
              class="flex  justify-between"
            >
              <div class="flex flex-col">
                <span><%= best_lap.track_name %></span>
                <span class="text-sm"><%= best_lap.layout_name %></span>
              </div>
              <span><%= Time.convert_milliseconds_to_lap_time(best_lap.best_lap) %></span>
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
    best_laps = Trackdays.list_best_laps(user_id)

    {:ok, assign(socket, latest_trackdays: latest_trackdays, best_laps: best_laps)}
  end
end
