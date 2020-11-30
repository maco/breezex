defmodule Breezex.Forms do
  @moduledoc """
  Module implementing the Breeze forms API.
  """
  alias Breezex.BreezeConfig
  alias Breezex.Client
  alias Breezex.Util

  @doc """
  List currently active forms
  """
  @spec list(map) :: Client.client_response()
  def list(%BreezeConfig{} = config),
    do: Client.get_request(config, "forms/list_forms")

  @spec list!(map) :: {map, list} | no_return
  def list!(%BreezeConfig{} = config) do
    list(config) |> Util.bang_output()
  end

  @doc """
  List archived forms
  """
  @spec list_archived(map) :: Client.client_response()
  def list_archived(%BreezeConfig{} = config),
    do: Client.get_request(config, "forms/list_forms", %{is_archived: 1})

  @spec list_archived!(map) :: {map, list} | no_return
  def list_archived!(%BreezeConfig{} = config) do
    list_archived(config) |> Util.bang_output()
  end

  @doc """
  List fields for a given form
  """
  @spec list_form_fields(map, integer()) :: Client.client_response()
  def list_form_fields(%BreezeConfig{} = config, id),
    do: Client.get_request(config, "forms/list_form_fields", %{form_id: id})

  @spec list_form_fields!(map, integer()) :: {map, list} | no_return
  def list_form_fields!(%BreezeConfig{} = config, id) do
    list_form_fields(config, id) |> Util.bang_output()
  end

  @doc """
  List entries for a given form id
  """
  @spec list_form_entries(map, integer()) :: Client.client_response()
  def list_form_entries(%BreezeConfig{} = config, id),
    do: Client.get_request(config, "forms/list_form_entries", %{form_id: id, details: 1})

  @spec list_form_entries!(map, integer()) :: {map, list} | no_return
  def list_form_entries!(%BreezeConfig{} = config, id) do
    list_form_entries(config, id) |> Util.bang_output()
  end

  @doc """
  Remove form entry
  """
  @spec remove_entry(map, integer()) :: Client.client_response()
  def remove_entry(%BreezeConfig{} = config, id),
    do: Client.get_request(config, "forms/remove_form_entry", %{entry_id: id})

  @spec remove_entry!(map, integer()) :: {map, list} | no_return
  def remove_entry!(%BreezeConfig{} = config, id) do
    remove_entry(config, id) |> Util.bang_output()
  end
end
