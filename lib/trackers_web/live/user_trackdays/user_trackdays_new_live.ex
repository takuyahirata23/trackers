defmodule TrackersWeb.UserTrackdaysNewLive do
  use TrackersWeb, :live_view

  alias TrackersWeb.Card
  alias Trackers.Trackdays
  alias Trackers.Trackdays.Trackday
  alias Trackers.Tracks
  alias Trackers.Motorcycles
  alias Trackers.Helpers.Time

  def render(assigns) do
    ~H"""
    <div>
      <Card.primary title="Create New Trackday">
        <.simple_form for={@form} phx-submit="create">
          <.input field={@form[:date]} type="date" label="Date" required />
          <.input
            field={@form[:layout_id]}
            type="select"
            options={@layout_options}
            value={nil}
            prompt="Select layout"
            label="Track Layout"
            required
          />
          <.input
            field={@form[:motorcycle_id]}
            type="select"
            options={@motorcycle_options}
            value={nil}
            prompt="Select motorcycle"
            label="Motorcycle"
            required
          />
          <div></div>
          <.input label="Best lap" field={@form[:best_lap]} placeholder="e.g. 1:23:140" />
          <.input label="Average lap" field={@form[:average_lap]} placeholder="e.g. 1:23:140" />
          <.input label="Note" field={@form[:note]} type="textarea" />
          <.input field={@form[:user_id]} type="hidden" value={@current_user.id} />
          <:actions>
            <.button phx-disable-with="Saving..." class="w-full">
              Save
            </.button>
          </:actions>
        </.simple_form>
      </Card.primary>
    </div>
    """
  end

  def mount(_parms, _session, socket) do
    form = Trackday.changeset(%Trackday{}) |> to_form()
    layout_options = Tracks.list_layouts_for_select()

    motorcycle_options =
      Motorcycles.list_user_motorcycles_for_select(socket.assigns.current_user.id)

    {:ok,
     assign(socket,
       form: form,
       motorcycle_options: motorcycle_options,
       layout_options: layout_options
     )}
  end

  def handle_event("create", %{"trackday" => attrs}, socket) do
    attrs = attrs |> convert_lap_time("best_lap") |> convert_lap_time("average_lap")

    case Trackdays.save_trackday(attrs) do
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "There was a problem saving trackday")
         |> assign(form: to_form(changeset))}

      {:ok, trackday} ->
        {:noreply,
         socket
         |> put_flash(:info, "Saved trackday")
         |> redirect(to: ~p"/users/trackdays/#{trackday.id}")}
    end
  end

  defp convert_lap_time(attrs, key) do
    Map.update(attrs, key, nil, fn current ->
      [m, s, ms] = String.split(current, ":")

      Time.convert_lap_time_to_milliseconds(%{
        "minutes" => String.to_integer(m),
        "seconds" => String.to_integer(s),
        "milliseconds" => String.to_integer(ms)
      })
    end)
  end
end
