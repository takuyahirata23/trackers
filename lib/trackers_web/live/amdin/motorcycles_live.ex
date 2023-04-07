defmodule TrackersWeb.Admin.Motorcycles do
  use TrackersWeb, :live_view

  alias Trackers.Motorcycles
  alias Trackers.Motorcycles.{Make, Model}
  alias TrackersWeb.Card

  def render(assigns) do
    ~H"""
    <div>
      <Card.primary title="Register make">
        <.simple_form for={@make_form} phx-submit="register-make">
          <.input field={@make_form[:name]} type="text" label="Name" required />
          <:actions>
            <.button phx-disable-with="Registering..." class="w-full">
              Register make <span aria-hidden="true">→</span>
            </.button>
          </:actions>
        </.simple_form>
      </Card.primary>
      <Card.primary title="Register model" class="mt-8">
        <.simple_form for={@model_form} phx-submit="register-model">
          <.input
            field={@model_form[:make_id]}
            type="select"
            options={@makes}
            value={nil}
            prompt="Select make"
            label="Make"
            required
          />
          <.input field={@model_form[:name]} type="text" label="Name" required />
          <:actions>
            <.button phx-disable-with="Registering..." class="w-full">
              Register model <span aria-hidden="true">→</span>
            </.button>
          </:actions>
        </.simple_form>
      </Card.primary>
      <Card.primary class="mt-8" title="Registered Motorcycles">
        <ul class="flex flex-col gap-y-8">
          <li :for={make <- @motorcycles}>
            <span class="font-bold"><%= make.name %></span>
            <ul class="flex flex-col gap-y-2 mt-2">
              <li :for={model <- make.models}>
                <span><%= model.name %></span>
              </li>
            </ul>
          </li>
        </ul>
      </Card.primary>
    </div>
    """
  end

  def mount(_, _, socket) do
    makes = Motorcycles.list_makes_for_select()
    motorcycles = Motorcycles.list_motorcycles()

    {:ok,
     assign(socket,
       make_form: gen_changeset(:make),
       model_form: gen_changeset(:model),
       makes: makes,
       motorcycles: motorcycles
     )}
  end

  def handle_event("register-make", %{"make" => attrs}, socket) do
    case Motorcycles.register_make(attrs) do
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "There was a problem registering a make")
         |> assign(make_form: to_form(changeset))}

      {:ok, make} ->
        {:noreply,
         socket
         |> put_flash(:info, "Registered #{make.name}")
         |> assign(make_form: gen_changeset(:make))}
    end
  end

  def handle_event("register-model", %{"model" => attrs}, socket) do
    case Motorcycles.register_model(attrs) do
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "There was a problem registering a model")
         |> assign(model_form: to_form(changeset))}

      {:ok, model} ->
        {:noreply,
         socket
         |> put_flash(:info, "Registered #{model.name}")
         |> assign(
           model_form: gen_changeset(:model),
           motorcycles: append_new_model(socket, model)
         )}
    end
  end

  defp gen_changeset(type) when is_atom(type) do
    case type do
      :make ->
        %Make{} |> Make.changeset() |> to_form()

      :model ->
        %Model{} |> Model.changeset() |> to_form()
    end
  end

  defp append_new_model(socket, model) do
    Enum.map(socket.assigns.motorcycles, fn make ->
      case make.id == model.make_id do
        false ->
          make

        true ->
          Map.replace(make, :models, Enum.concat(make.models, [model]))
      end
    end)
  end
end
