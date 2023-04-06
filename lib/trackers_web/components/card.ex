defmodule TrackersWeb.Card do
  use Phoenix.Component

  attr :title, :string, default: nil
  slot :inner_block, required: true

  def primary(assigns) do
    ~H"""
    <div class="bg-bg-secondary rounded p-4">
      <span :if={@title} class="mb-2 text-lg font-bold block"><%= @title %></span>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
