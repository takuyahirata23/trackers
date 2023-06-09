defmodule TrackersWeb.UserMotorcycleMaintenaceNewLive do
  use TrackersWeb, :live_view

  alias Trackers.Motorcycles
  alias Trackers.Motorcycles.Maintenance

  alias TrackersWeb.Card

  def render(assigns) do
    ~H"""
    <div>
      <Card.primary title="Create New Trackday">
        <.simple_form for={@form} phx-submit="create">
          <.input field={@form[:title]} label="Title" required />
          <.input field={@form[:date]} type="date" label="Date" required />
          <.input
            field={@form[:motorcycle_id]}
            type="select"
            options={@motorcycle_options}
            value={nil}
            prompt="Select motorcycle"
            label="Motorcycle"
            required
          />
          <.input field={@form[:odometer]} type="number" label="Odometer" step="1" />
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
    form = Maintenance.changeset(%Maintenance{}) |> to_form()

    motorcycle_options =
      Motorcycles.list_user_motorcycles_for_select(socket.assigns.current_user.id)

    {:ok, assign(socket, form: form, motorcycle_options: motorcycle_options)}
  end

  def handle_event("create", %{"maintenance" => attrs}, socket) do
    case Motorcycles.save_maintenance(attrs) do
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "There was a problem saving maintenance record")
         |> assign(form: to_form(changeset))}

      {:ok, _maintenance} ->
        form = Maintenance.changeset(%Maintenance{}) |> to_form()

        {:noreply,
         socket
         |> put_flash(:info, "Saved maintenance record")
         |> assign(form: form)}
    end
  end
end
