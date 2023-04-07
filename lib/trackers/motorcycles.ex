defmodule Trackers.Motorcycles do
  @moduledoc """
  The Motorcycles context.
  """

  import Ecto.Query, warn: false

  alias Trackers.Repo
  alias Trackers.Motorcycles.{Make, Model, Motorcycle}

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

  def list_models_for_select(make_id) when is_binary(make_id) do
    Repo.all(
      from m in Model, where: m.make_id == ^make_id, select: {m.name, m.id}, order_by: m.name
    )
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

  def register_motorcycle(attrs) do
    case %Motorcycle{}
         |> Motorcycle.changeset(attrs)
         |> Repo.insert() do
      {:ok, motorcycle} -> {:ok, Repo.preload(motorcycle, [:make, :model])}
      error -> error
    end
  end

  def list_user_motorcycles(user_id) when is_binary(user_id) do
    Repo.all(from m in Motorcycle, where: m.user_id == ^user_id, preload: [:make, :model])
  end

  def get_user_motorcycle(user_id, motorcycle_id)
      when is_binary(user_id) and is_binary(motorcycle_id) do
    Repo.one(
      from m in Motorcycle,
        where: m.user_id == ^user_id and m.id == ^motorcycle_id,
        preload: [:make, :model]
    )
  end
end
