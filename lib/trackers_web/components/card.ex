defmodule TrackersWeb.Card do
  use Phoenix.Component

  attr :title, :string, default: nil
  attr :class, :string, default: nil
  attr :margin_bottom, :boolean, default: true
  slot :inner_block
  slot :action

  def primary(assigns) do
    ~H"""
    <div class={[
      "bg-bg-secondary rounded p-4 drop-shadow-md",
      @class
    ]}>
      <div class={["flex justify-between items-center", @margin_bottom && "mb-6"]}>
        <span :if={@title} class="text-lg font-bold block"><%= @title %></span>
        <%= render_slot(@action) %>
      </div>
      <%= if @inner_block do %>
        <%= render_slot(@inner_block) %>
      <% end %>
    </div>
    """
  end
end
