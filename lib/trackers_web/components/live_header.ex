defmodule TrackersWeb.Header do
  use Phoenix.Component
  use TrackersWeb, :verified_routes

  alias Phoenix.LiveView.JS

  def live(assigns) do
    ~H"""
    <header class="py-4 bg-bg-secondary">
      <div class="max-w-7xl w-11/12 mx-auto flex justify-between items-center">
        <h1 class="font-bold text-xl">Tracker Admin</h1>
        <button phx-click={toggle_mobile_menu()} id="open" class="block p-2">
          <Heroicons.Outline.menu class="w-6 h-6" />
        </button>
        <button phx-click={toggle_mobile_menu()} id="close" class="hidden p-2">
          <Heroicons.Outline.x class="w-6 h-6" />
        </button>
      </div>
      <div id="backdrop" class="z-10 fixed h-screen inset-x-0 bg-bg-secondary opacity-50 hidden">
      </div>
      <nav
        id="mobile-navigation"
        class="z-20 fixed bg-bg-secondary h-screen right-0  drop-shadow-md hidden w-2/3 p-8"
      >
        <.link navigate={~p"/users/motorcycles"}>Motorcycles</.link>
      </nav>
    </header>
    """
  end

  def toggle_mobile_menu do
    JS.toggle(
      to: "#mobile-navigation",
      in: {"ease-in-out duration-300", "translate-x-full", "translate-x-0"},
      out: {"ease-in-out duration-300", "translate-x-0", "translate-x-full"},
      time: 300
    )
    |> JS.toggle(to: "#open")
    |> JS.toggle(to: "#close")
    |> JS.toggle(to: "#backdrop", in: "fade-in", out: "fade-out")
  end
end
