defmodule TrackersWeb.UserMotorcycleDetailLive do
  use TrackersWeb, :live_view

  alias TrackersWeb.Card
  alias Trackers.Motorcycles
  # alias Trackers.Motorcycles.Motorcycle

  def render(assigns) do
    ~H"""
    <Card.primary title={"#{@motorcycle.make.name} #{@motorcycle.model.name} (#{@motorcycle.year})"}>
    </Card.primary>
    """
  end

  def mount(%{"id" => motorcycle_id}, _, socket) do
    %{id: user_id} = socket.assigns.current_user
    motorcycle = Motorcycles.get_user_motorcycle(user_id, motorcycle_id)
    {:ok, assign(socket, motorcycle: motorcycle)}
  end
end
