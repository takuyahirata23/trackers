defmodule TrackersWeb.UserTrackdayDetailLive do
  use TrackersWeb, :live_view

  alias Trackers.Trackdays
  alias TrackersWeb.Card
  alias Trackers.Helpers.Time

  def mount(%{"id" => id}, _seeesion, socket) do
    trackday = Trackdays.get_trackday_by_id(id)
    IO.inspect(trackday)
    {:ok, assign(socket, trackday: trackday)}
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-y-6">
      <Card.primary title={@trackday.layout.track.name}>
        <div class="flex justify-between">
          <span><%= @trackday.layout.name %></span>
          <span><%= @trackday.date %></span>
        </div>
      </Card.primary>
      <Card.primary title="Motorcycle">
        <div class="">
          <span>
            <%= "#{@trackday.motorcycle.make.name} - #{@trackday.motorcycle.model.name} (#{@trackday.motorcycle.year})" %>
          </span>
        </div>
      </Card.primary>
      <Card.primary title="Lap time">
        <div class="flex flex-col gap-y-4">
          <span>Best lap: <%= Time.convert_milliseconds_to_lap_time(@trackday.best_lap) %></span>
          <span>
            Average lap: <%= Time.convert_milliseconds_to_lap_time(@trackday.average_lap) %>
          </span>
        </div>
      </Card.primary>
      <Card.primary title="Note">
        <p><%= @trackday.note %></p>
      </Card.primary>
    </div>
    """
  end
end
