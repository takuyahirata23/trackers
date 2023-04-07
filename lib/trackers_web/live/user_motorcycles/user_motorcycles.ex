defmodule TrackersWeb.UserMotorcyclesLive do
  use TrackersWeb, :live_view

  alias TrackersWeb.Card

  def render(assigns) do
    ~H"""
    <dvi class="flex flex-col gap-y-8">
      <Card.primary title="My motorcycles">
        <div>Your don't have any motorcycle registered yet</div>
      </Card.primary>
      <Card.primary title="Register motorcycle">
        <div>form</div>
      </Card.primary>
    </dvi>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
