defmodule Trackers.Helpers.Time do
  def convert_lap_time_to_milliseconds(%{
        "minutes" => minutes,
        "seconds" => seconds,
        "milliseconds" => milliseconds
      }) do
    :timer.minutes(minutes) + :timer.seconds(seconds) + milliseconds * 10
  end

  def convert_milliseconds_to_lap_time(lap_time_in_milliseconds) do
    minute = Integer.floor_div(lap_time_in_milliseconds, 60000)

    [seconds, milliseconds] =
      (Integer.mod(lap_time_in_milliseconds, 60000) / 1000)
      |> Float.to_string()
      |> String.split(".")
      |> Enum.map(&add_zero(&1))

    "#{minute}:#{seconds}:#{milliseconds}"
  end

  defp add_zero(time) do
    case String.length(time) do
      1 -> "0#{time}"
      _ -> time
    end
  end
end
