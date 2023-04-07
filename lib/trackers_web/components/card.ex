defmodule TrackersWeb.Card do
  use Phoenix.Component

  attr :title, :string, default: nil
  attr :class, :string, default: nil
  slot :inner_block, required: true

  def primary(assigns) do
    ~H"""
    <div class={[
      "bg-bg-secondary rounded p-4 drop-shadow-md",
      @class
    ]}>
      <span :if={@title} class="mb-6 text-lg font-bold block"><%= @title %></span>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
