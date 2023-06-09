defmodule TrackersWeb.UserMotorcycleDetailLive do
  use TrackersWeb, :live_view

  alias TrackersWeb.Card
  alias Trackers.Motorcycles

  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-y-8">
      <Card.primary title={"#{@motorcycle.make.name} #{@motorcycle.model.name}"} margin_bottom={false}>
        <:action>
          <span class="text-sm"><%= @motorcycle.year %></span>
        </:action>
      </Card.primary>
      <Card.primary title="Maintenace Record">
        <:action>
          <.link navigate={~p"/users/motorcycles/#{@motorcycle.id}/maintenances/new"}>
            <.icon name="hero-plus-solid" class="h-6 w-6" />
          </.link>
        </:action>
        <ul :if={!Enum.empty?(@motorcycle.maintenances)}>
          <li :for={maintenance <- @motorcycle.maintenances}>
            <.link
              navigate={~p"/users/motorcycles/#{@motorcycle.id}/maintenances/#{maintenance.id}"}
              class="flex justify-between gap-x-4"
            >
              <span>
                <%= maintenance.title %>
              </span>
              <span>
                <%= maintenance.date %>
              </span>
            </.link>
          </li>
        </ul>
      </Card.primary>
      <.back_button url={~p"/users/motorcycles"} label="Motorcycles" />
    </div>
    """
  end

  def mount(%{"id" => motorcycle_id}, _, socket) do
    %{id: user_id} = socket.assigns.current_user
    motorcycle = Motorcycles.get_user_motorcycle(user_id, motorcycle_id)
    {:ok, assign(socket, motorcycle: motorcycle)}
  end
end
