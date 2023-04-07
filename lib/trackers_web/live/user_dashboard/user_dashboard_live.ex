defmodule TrackersWeb.UserDashboardLive do
  use TrackersWeb, :live_view

  def render(assigns) do
    ~H"""
    <div>here</div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
