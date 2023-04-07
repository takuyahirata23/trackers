defmodule TrackersWeb.UserMotorcyclesLive do
  use TrackersWeb, :live_view

  alias TrackersWeb.Card
  alias Trackers.Motorcycles
  alias Trackers.Motorcycles.Motorcycle

  def render(assigns) do
    ~H"""
    <dvi class="flex flex-col gap-y-8">
      <Card.primary title="My motorcycles">
        <p :if={Enum.empty?(@streams.motorcycles.inserts)}>
          Your don't have any motorcycle registered yet
        </p>
        <ul id="motorcycles" phx-update="stream">
          <li :for={{dom_id, motorcycle} <- @streams.motorcycles} id={dom_id}>
            <.link navigate={~p"/users/motorcycles/#{motorcycle.id}"}>
              <%= "#{motorcycle.make.name} #{motorcycle.model.name} #{motorcycle.year}" %>
            </.link>
          </li>
        </ul>
      </Card.primary>
      <Card.primary title="Register motorcycle">
        <.simple_form for={@form} phx-submit="register-motorcycle">
          <.input
            field={@form[:year]}
            label="Year"
            type="number"
            required
            max={DateTime.utc_now() |> Map.fetch!(:year)}
            min="1800"
            data-phx-update="ignore"
          />
          <.input
            field={@form[:make_id]}
            type="select"
            options={@makes}
            value={nil}
            prompt="Select make"
            label="Make"
            required
            phx-change="select-make"
          />
          <.input
            disabled={length(@models) == 0}
            field={@form[:model_id]}
            type="select"
            options={@models}
            value={nil}
            prompt="Select model"
            label="Model"
            required
          />
          <.input field={@form[:user_id]} type="hidden" value={@user_id} />

          <:actions>
            <.button phx-disable-with="Registering..." class="w-full">
              Register motorcycle <span aria-hidden="true">→</span>
            </.button>
          </:actions>
        </.simple_form>
      </Card.primary>
    </dvi>
    """
  end

  def mount(_params, _session, socket) do
    user_id = socket.assigns.current_user.id
    form = Motorcycle.changeset(%Motorcycle{}) |> to_form()
    makes = Motorcycles.list_makes_for_select()
    motorcycles = Motorcycles.list_user_motorcycles(user_id)

    {:ok,
     assign(socket,
       form: form,
       makes: makes,
       models: [],
       user_id: user_id
     )
     |> stream(:motorcycles, motorcycles)}
  end

  def handle_event("select-make", %{"motorcycle" => attrs}, socket) do
    models = Motorcycles.list_models_for_select(attrs["make_id"])
    {:noreply, update(socket, :models, fn _ -> models end)}
  end

  def handle_event("register-motorcycle", %{"motorcycle" => attrs}, socket) do
    case Motorcycles.register_motorcycle(attrs) do
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> put_flash(
           :error,
           "There was a problem registering a motorcycle. Have you alrady registered the motorcycle?"
         )
         |> assign(model_form: to_form(changeset))}

      {:ok, motorcycle} ->
        {:noreply,
         socket
         |> put_flash(:info, "Registered motorcycle")
         |> assign(
           form: Motorcycle.changeset(%Motorcycle{}) |> to_form(),
           models: []
         )
         |> stream_insert(:motorcycles, motorcycle)}
    end
  end
end
