defmodule TrackersWeb.LayoutLive do
  use TrackersWeb, :live_view

  alias Trackers.Tracks
  alias Trackers.Helpers.Time
  alias Trackers.Laps.FastLap
  alias Trackers.Laps
  alias Trackers.Motorcycles

  alias TrackersWeb.Card

  def render(assigns) do
    ~H"""
    <h2 class="font-bold text-xl"><%= "#{@track_layout.name}" %></h2>
    <p :if={@track_layout.description} class="mt-4"><%= "#{@track_layout.description}" %></p>
    <div class="flex flex-col gap-y-8">
      <Card.primary title="Fast lap time a day">
        <.simple_form for={@form} phx-submit="save-fast-lap">
          <.input field={@form[:lap_time]} type="hidden" />
          <.input field={@form[:date]} type="date" label="Date" required />
          <input
            type="number"
            name="minutes"
            required
            class="rounded border-zinc-300 text-zinc-900 focus:ring-0"
          />
          <input
            type="number"
            name="seconds"
            required
            class="rounded border-zinc-300 text-zinc-900 focus:ring-0"
          />
          <input
            type="number"
            name="milliseconds"
            required
            class="rounded border-zinc-300 text-zinc-900 focus:ring-0"
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
          <.input field={@form[:user_id]} type="hidden" value={@user_id} />
          <.input field={@form[:layout_id]} type="hidden" value={@layout_id} />
          <:actions>
            <.button phx-disable-with="Saving..." class="w-full">
              Save today's fast lap <span aria-hidden="true">→</span>
            </.button>
          </:actions>
        </.simple_form>
      </Card.primary>
      <Card.primary :if={!Enum.empty?(@fast_laps)} title="Lap Times">
        <ol class="flex flex-col gap-y-4 mt-6">
          <li :for={fast_lap <- @fast_laps} class="flex gap-x-2">
            <div>
              <%= "#{Time.convert_milliseconds_to_lap_time(fast_lap.lap_time)}" %>
            </div>
            <div>
              <%= "#{fast_lap.date}" %>
            </div>
          </li>
        </ol>
      </Card.primary>
    </div>
    """
  end

  def mount(%{"layout_id" => layout_id}, _session, socket) do
    track_layout = Tracks.get_layout_by_id(layout_id)
    form = FastLap.changeset(%FastLap{}) |> to_form
    user_id = socket.assigns.current_user.id
    fast_laps = Laps.list_fast_laps_for_layout(layout_id)

    motorcycle_options =
      Motorcycles.list_user_motorcycles_for_select(socket.assigns.current_user.id)

    {:ok,
     assign(socket,
       track_layout: track_layout,
       form: form,
       layout_id: layout_id,
       motorcycle_options: motorcycle_options,
       user_id: user_id,
       layout_id: layout_id,
       fast_laps: fast_laps
     )}
  end

  def handle_event(
        "save-fast-lap",
        %{
          "fast_lap" => fast_lap,
          "minutes" => minutes,
          "seconds" => seconds,
          "milliseconds" => milliseconds
        },
        socket
      ) do
    lap_time = %{
      "minutes" => String.to_integer(minutes),
      "seconds" => String.to_integer(seconds),
      "milliseconds" => String.to_integer(milliseconds)
    }

    attrs = %{
      fast_lap
      | "lap_time" => Time.convert_lap_time_to_milliseconds(lap_time)
    }

    IO.inspect(attrs, label: "Attrs")

    case Laps.insert_fast_lap_a_day(attrs) do
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> put_flash(:error, "Error") |> assign(form: to_form(changeset))}

      {:ok, fast_lap} ->
        IO.inspect(fast_lap)
        form = FastLap.changeset(%FastLap{}) |> to_form
        {:noreply, socket |> put_flash(:info, "Success") |> assign(form: form)}
    end
  end
end
