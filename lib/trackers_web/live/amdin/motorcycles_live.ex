defmodule TrackersWeb.Admin.Motorcycles do
  use TrackersWeb, :live_view

  alias Trackers.Motorcycles.Make
  alias Trackers.Motorcycles

  def render(assigns) do
    ~H"""
    <div>
      <.simple_form for={@form} phx-submit="register-make">
        <.input field={@form[:name]} type="text" label="Name" required />
        <:actions>
          <.button phx-disable-with="Registering..." class="w-full">
            Register make <span aria-hidden="true">→</span>
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_, _, socket) do
    form = %Make{} |> Make.changeset() |> to_form()

    {:ok, assign(socket, form: form)}
  end

  def handle_event("register-make", %{"make" => attrs}, socket) do
    case Motorcycles.register_make(attrs) do
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "There was a problem registering a make")
         |> assign(form: to_form(changeset))}

      {:ok, make} ->
        {:noreply, socket |> put_flash(:info, "Registered #{make.name}")}
    end
  end
end
