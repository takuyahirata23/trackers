defmodule Tracker.Helpers.Time do
  def convert_lap_time_milliseconds(%{
        "minutes" => minutes,
        "seconds" => seconds,
        "miliseconds" => miliseconds
      }) do
    :timer.minutes(minutes) + :timer.seconds(seconds) + miliseconds
  end

  def convert_lap_time_milliseconds(lap) do
    minute = Integer.floor_div(lap, 60000)
    seconds = (Integer.mod(lap, 60000) / 1000) |> Float.to_string() |> String.replace(".", ":")
    "#{minute}:#{seconds}"
  end
end
