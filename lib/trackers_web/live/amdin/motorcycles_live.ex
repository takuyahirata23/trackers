defmodule TrackersWeb.Admin.Motorcycles do
  use TrackersWeb, :live_view

  def mount(_, _, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      here
    </div>
    """
  end
end
