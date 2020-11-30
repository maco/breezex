defmodule Breezex.Volunteers do
  @moduledoc """
  Module implementing the Breeze volunteers API.
  """
  alias Breezex.BreezeConfig
  alias Breezex.Client
  alias Breezex.Util

  @doc """
  List volunteers from a specific event
  """
  @spec list_for_event(map, integer()) :: Client.client_response()
  def list_for_event(%BreezeConfig{} = config, id),
    do: Client.get_request(config, "volunteers/list", %{instance_id: id})

  @spec list_for_event!(map, integer()) :: {map, list} | no_return
  def list_for_event!(%BreezeConfig{} = config, id) do
    list_for_event(config, id) |> Util.bang_output()
  end

  @doc """
  Schedule a volunteer for an event
  """
  @spec add_to_event(map, integer(), integer()) :: Client.client_response()
  def add_to_event(%BreezeConfig{} = config, event_id, person_id),
    do:
      Client.get_request(config, "volunteers/add", %{instance_id: event_id, person_id: person_id})

  @spec add_to_event!(map, integer(), integer()) :: {map, list} | no_return
  def add_to_event!(%BreezeConfig{} = config, event_id, person_id) do
    add_to_event(config, event_id, person_id) |> Util.bang_output()
  end

  @doc """
  Un-schedule a volunteer for an event
  """
  @spec remove_from_event(map, integer(), integer()) :: Client.client_response()
  def remove_from_event(%BreezeConfig{} = config, event_id, person_id),
    do:
      Client.get_request(config, "volunteers/remove", %{
        instance_id: event_id,
        person_id: person_id
      })

  @spec remove_from_event!(map, integer(), integer()) :: {map, list} | no_return
  def remove_from_event!(%BreezeConfig{} = config, event_id, person_id) do
    remove_from_event(config, event_id, person_id) |> Util.bang_output()
  end

  @doc """
  Update a volunteer's roles for an event
  """
  @spec update_roles(map, integer(), integer(), list) :: Client.client_response()
  def update_roles(%BreezeConfig{} = config, event_id, person_id, roles),
    do:
      Client.get_request(config, "volunteers/update", %{
        instance_id: event_id,
        person_id: person_id,
        role_ids_json: Poison.encode!(roles)
      })

  @spec update_roles!(map, integer(), integer(), list) :: {map, list} | no_return
  def update_roles!(%BreezeConfig{} = config, event_id, person_id, roles) do
    update_roles(config, event_id, person_id, roles) |> Util.bang_output()
  end

  @doc """
  List roles for an event
  """
  @spec list_roles(map, integer()) :: Client.client_response()
  def list_roles(%BreezeConfig{} = config, id),
    do: Client.get_request(config, "volunteers/list_roles", %{instance_id: id, show_quantity: 1})

  @spec list_roles!(map, integer()) :: {map, list} | no_return
  def list_roles!(%BreezeConfig{} = config, id) do
    list_roles(config, id) |> Util.bang_output()
  end

  @doc """
  Add a volunteer role to an event.

  Optionally include a quantity of volunteers needed for that role.
  Note: quantity will overwrite current quantity setting for the series.
  """
  @spec add_role_to_event(map, integer(), String.t()) :: Client.client_response()
  def add_role_to_event(%BreezeConfig{} = config, event_id, name),
    do:
      Client.get_request(config, "volunteers/add_role", %{
        instance_id: event_id,
        name: name
      })

  @spec add_role_to_event!(map, integer(), String.t()) :: {map, list} | no_return
  def add_role_to_event!(%BreezeConfig{} = config, event_id, name) do
    add_role_to_event(config, event_id, name) |> Util.bang_output()
  end

  @spec add_role_to_event(map, integer(), String.t(), integer()) :: Client.client_response()
  def add_role_to_event(%BreezeConfig{} = config, event_id, name, quantity),
    do:
      Client.get_request(config, "volunteers/add_role", %{
        instance_id: event_id,
        name: name,
        quantity: quantity
      })

  @spec add_role_to_event!(map, integer(), String.t(), integer()) :: {map, list} | no_return
  def add_role_to_event!(%BreezeConfig{} = config, event_id, name, quantity) do
    add_role_to_event(config, event_id, name, quantity) |> Util.bang_output()
  end

  @doc """
  Remove role from event
  """
  @spec remove_role_from_event(map, integer(), integer()) :: Client.client_response()
  def remove_role_from_event(%BreezeConfig{} = config, event_id, role_id),
    do:
      Client.get_request(config, "volunteers/remove_role", %{
        instance_id: event_id,
        role_id: role_id
      })

  @spec remove_role_from_event!(map, integer(), integer()) :: {map, list} | no_return
  def remove_role_from_event!(%BreezeConfig{} = config, event_id, role_id) do
    remove_role_from_event(config, event_id, role_id) |> Util.bang_output()
  end
end
