defmodule Breezex.Families do
  @moduledoc """
  Module implementing the Breeze families API.
  """
  alias Breezex.BreezeConfig
  alias Breezex.Client
  alias Breezex.Util

  @doc """
  Creates a new family grouping from pre-existing people.

  If anyone is already in a family, they'll be removed from the old one.
  """
  @spec create(map, list) :: Client.client_response()
  def create(%BreezeConfig{} = config, ids),
    do: Client.get_request(config, "families/create", %{people_ids_json: Poison.encode!(ids)})

  @spec create!(map, list) :: {map, list} | no_return
  def create!(%BreezeConfig{} = config, ids) do
    create(config, ids) |> Util.bang_output()
  end

  @doc """
  Destroy the family grouping belonging to the person whose ID is passed in.

  If a list is passed in, destroy any family containing any person whose ID is in the list.
  """
  @spec destroy(map, list | integer()) :: Client.client_response()
  def destroy(%BreezeConfig{} = config, [_ | _] = ids),
    do: Client.get_request(config, "families/destroy", %{people_ids_json: Poison.encode!(ids)})

  def destroy(%BreezeConfig{} = config, id),
    do: Client.get_request(config, "families/destroy", %{people_ids_json: Poison.encode!([id])})

  @spec destroy!(map, integer() | list) :: {map, list} | no_return
  def destroy!(%BreezeConfig{} = config, id) do
    destroy(config, id) |> Util.bang_output()
  end

  @doc """
  Updates family to which `member_id` belongs, adding everyone in `new_people` list.
  """
  @spec add_to_family(map, integer(), list) :: Client.client_response()
  def add_to_family(%BreezeConfig{} = config, member_id, new_people),
    do:
      Client.get_request(config, "families/add", %{
        target_person_id: member_id,
        people_ids_json: Poison.encode!(new_people)
      })

  @spec add_to_family!(map, integer(), list) :: {map, list} | no_return
  def add_to_family!(%BreezeConfig{} = config, member_id, new_people) do
    add_to_family(config, member_id, new_people) |> Util.bang_output()
  end

  @doc """
  Remove people from whatever family they're in
  """
  @spec remove_from_family(map, integer() | list) :: Client.client_response()
  def remove_from_family(%BreezeConfig{} = config, [_ | _] = ids),
    do: Client.get_request(config, "families/remove", %{people_ids_json: Poison.encode!(ids)})

  def remove_from_family(%BreezeConfig{} = config, id),
    do: Client.get_request(config, "families/remove", %{people_ids_json: Poison.encode!([id])})

  @spec remove_from_family!(map, integer() | list) :: {map, list} | no_return
  def remove_from_family!(%BreezeConfig{} = config, id) do
    remove_from_family(config, id) |> Util.bang_output()
  end
end
