defmodule Trackers.Motorcycles do
  @moduledoc """
  The Motorcycles context.
  """

  import Ecto.Query, warn: false

  alias Trackers.Repo
  alias Trackers.Motorcycles.Make

  def register_make(attrs) do
    %Make{}
    |> Make.changeset(attrs)
    |> Repo.insert()
  end
end
