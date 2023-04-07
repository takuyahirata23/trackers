defmodule Trackers.Motorcycles do
  @moduledoc """
  The Motorcycles context.
  """

  import Ecto.Query, warn: false

  alias Trackers.Repo
  alias Trackers.Motorcycles.{Make, Model}

  def register_make(attrs) do
    %Make{}
    |> Make.changeset(attrs)
    |> Repo.insert()
  end

  def list_makes_for_select do
    Make
    |> select([m], {m.name, m.id})
    |> order_by([m], asc: m.name)
    |> Repo.all()
  end

  def register_model(attrs) do
    %Model{}
    |> Model.changeset(attrs)
    |> Repo.insert()
  end

  def list_motorcycles do
    Make
    |> preload(:models)
    |> order_by(asc: :name)
    |> Repo.all()
  end
end
