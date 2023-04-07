defmodule TrackersWeb.Admin.TracksLive do
  use TrackersWeb, :live_view

  alias Trackers.Tracks
  alias Trackers.Tracks.{Track, Layout}
  alias TrackersWeb.Card

  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-y-8">
      <Card.primary title="Tracks">
        <p :if={Enum.empty?(@tracks)}>
          No tracks have been registered yet
        </p>
        <ul class="flex flex-col gap-y-6">
          <li :for={track <- @tracks}>
            <p class="font-bold">
              <%= "#{track.name}" %>
            </p>
            <ul>
              <li :for={layout <- track.layouts}>
                <p>
                  <%= "#{layout.name}" %>
                </p>
              </li>
            </ul>
          </li>
        </ul>
      </Card.primary>
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
      <Card.primary title="Register layout">
        <.simple_form for={@layout_form} phx-submit="register-layout">
          <.input
            field={@layout_form[:track_id]}
            type="select"
            label="Track"
            options={@tracks_options}
            prompt="Select track"
            required
          />
          <.input field={@layout_form[:name]} type="text" label="Name" required />
          <.input field={@layout_form[:description]} type="textarea" label="description" />
          <.input field={@layout_form[:length]} type="number" step="0.001" label="Length" required />
          <:actions>
            <.button phx-disable-with="Registering..." class="w-full">
              Register track <span aria-hidden="true">→</span>
            </.button>
          </:actions>
        </.simple_form>
      </Card.primary>
    </div>
    """
  end

  def mount(_, _, socket) do
    tracks_options = Tracks.list_tracks_for_select()
    tracks = Tracks.list_registered_tracks()

    {:ok,
     assign(socket,
       track_form: gen_changeset(:track),
       layout_form: gen_changeset(:layout),
       tracks_options: tracks_options,
       tracks: tracks
     )}
  end

  def handle_event("register-track", %{"track" => attrs}, socket) do
    case Tracks.register_track(attrs) do
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "There was a problem registering a track")
         |> assign(track_form: to_form(changeset))}

      {:ok, track} ->
        {:noreply,
         socket
         |> put_flash(:info, "Registered #{track.name}")
         |> assign(track_form: gen_changeset(:track))
         |> update(:tracks_options, fn tracks -> Enum.concat(tracks, [{track.name, track.id}]) end)}
    end
  end

  def handle_event("register-layout", %{"layout" => attrs}, socket) do
    case Tracks.register_layout(attrs) do
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "There was a problem registering a layout")
         |> assign(track_form: to_form(changeset))}

      {:ok, layout} ->
        {:noreply,
         socket
         |> put_flash(:info, "Registered #{layout.name}")
         |> assign(track_form: gen_changeset(:track), tracks: Tracks.list_registered_tracks())}
    end
  end

  defp gen_changeset(type) when is_atom(type) do
    case type do
      :track ->
        %Track{} |> Track.changeset() |> to_form()

      :layout ->
        %Layout{} |> Layout.changeset() |> to_form()
    end
  end
end
