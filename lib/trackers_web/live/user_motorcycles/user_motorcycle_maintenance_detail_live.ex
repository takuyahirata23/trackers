defmodule TrackersWeb.UserMotorcycleMaintenanceDetailLive do
  use TrackersWeb, :live_view

  alias Trackers.Motorcycles

  alias TrackersWeb.Card

  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-y-8">
      <Card.primary title={"#{@maintenance.make} - #{@maintenance.model}"} margin_bottom={false}>
        <:action>
          <span class="text-sm"><%= @maintenance.year %></span>
        </:action>
      </Card.primary>
      <Card.primary title={@maintenance.title} margin_bottom={false}>
        <:action>
          <span class="text-sm"><%= @maintenance.date %></span>
        </:action>
      </Card.primary>
      <Card.primary :if={@maintenance.odometer} title="Odemeter">
        <span>
          <%= @maintenance.odometer %>
        </span>
      </Card.primary>
      <Card.primary :if={@maintenance.note} title="Note">
        <p>
          <%= @maintenance.note %>
        </p>
      </Card.primary>
      <.back_button
        url={~p"/users/motorcycles/#{@maintenance.motorcycle_id}"}
        label={"#{@maintenance.make} - #{@maintenance.model}" }
      />
    </div>
    """
  end

  def mount(%{"maintenance_id" => id}, _session, socket) do
    maintenance = Motorcycles.get_maintenance_by_id(id)
    {:ok, assign(socket, maintenance: maintenance)}
  end
end
