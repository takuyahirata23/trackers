defmodule TrackersWeb.Admin.TracksLive do
  use TrackersWeb, :live_view

  alias Trackers.Tracks
  alias Trackers.Tracks.Track
  alias TrackersWeb.Card

  def render(assigns) do
    ~H"""
    <Card.primary title="Register track">
      <.simple_form for={@track_form} phx-submit="register-track">
        <.input field={@track_form[:name]} type="text" label="Name" required />
        <.input field={@track_form[:description]} type="textarea" label="description" />
        <:actions>
          <.button phx-disable-with="Registering..." class="w-full">
            Register track <span aria-hidden="true">→</span>
          </.button>
        </:actions>
      </.simple_form>
    </Card.primary>
    """
  end

  def mount(_, _, socket) do
    track_form = Track.changeset(%Track{}) |> to_form()

    {:ok, assign(socket, track_form: track_form)}
  end

  def handle_event("register-track", %{"track" => attrs}, socket) do
    case Tracks.register_track(attrs) do
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "There was a problem registering a track")
         |> assign(track_form: to_form(changeset))}

      {:ok, track} ->
        track_form = Track.changeset(%Track{}) |> to_form()

        {:noreply,
         socket |> put_flash(:info, "Registered #{track.name}") |> assign(track_form: track_form)}
    end
  end
end
