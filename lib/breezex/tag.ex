defmodule Breezex.Tag do
  @moduledoc """
  Module implementing the Breeze tags API.
  """
  alias Breezex.BreezeConfig
  alias Breezex.Client
  alias Breezex.Util

  @doc """
  List all tags in Breeze
  """

  @spec list_tags(map) :: Client.client_response()
  def list_tags(%BreezeConfig{} = config), do: Client.get_request(config, "tags/list_tags")

  @spec list_tags!(map) :: {map, list} | no_return
  def list_tags!(%BreezeConfig{} = config) do
    list_tags(config) |> Util.bang_output()
  end

  @doc """
  List all tags in a particular folder, by folder ID
  """

  @spec list_tags(map, String.t() | integer()) :: Client.client_response()
  def list_tags(%BreezeConfig{} = config, id),
    do: Client.get_request(config, "tags/list_tags", %{folder_id: id})

  @spec list_tags!(map, String.t() | integer()) :: {map, list} | no_return
  def list_tags!(%BreezeConfig{} = config, id) do
    list_tags(config, id) |> Util.bang_output()
  end

  @doc """
  List all folders in Breeze
  """

  @spec list_folders(map) :: Client.client_response()
  def list_folders(%BreezeConfig{} = config), do: Client.get_request(config, "tags/list_folders")

  @spec list_folders!(map) :: {map, list} | no_return
  def list_folders!(%BreezeConfig{} = config) do
    list_folders(config) |> Util.bang_output()
  end

  @doc """
  List people who are in a given tag, using the tag's ID
  """

  @spec list_people(map, String.t()) :: Client.client_response()
  def list_people(%BreezeConfig{} = config, id) do
    filter =
      %{tag_contains: id}
      |> Poison.encode!()

    Client.get_request(config, "people", %{filter_json: filter})
  end

  @spec list_people!(map, String.t()) :: {map, list} | no_return
  def list_people!(%BreezeConfig{} = config, id) do
    list_people(config, id) |> Util.bang_output()
  end

  @doc """
  Add a tag.

  Name required. Optionally, provide a parent folder ID.
  """
  @spec add_tag(map, String.t()) :: Client.client_response()
  def add_tag(%BreezeConfig{} = config, name),
    do: Client.get_request(config, "tags/add_tag", %{name: name})

  @spec add_tag!(map, String.t()) :: {map, list} | no_return
  def add_tag!(%BreezeConfig{} = config, name) do
    add_tag(config, name) |> Util.bang_output()
  end

  @spec add_tag(map, String.t(), integer()) :: Client.client_response()
  def add_tag(%BreezeConfig{} = config, name, folder_id),
    do: Client.get_request(config, "tags/add_tag", %{name: name, folder_id: folder_id})

  @spec add_tag!(map, String.t(), integer()) :: {map, list} | no_return
  def add_tag!(%BreezeConfig{} = config, name, folder_id) do
    add_tag(config, name, folder_id) |> Util.bang_output()
  end

  @doc """
  Add a folder.

  Name required. Optionally, provide a parent folder ID.
  """
  @spec add_folder(map, String.t()) :: Client.client_response()
  def add_folder(%BreezeConfig{} = config, name),
    do: Client.get_request(config, "tags/add_folder", %{name: name})

  @spec add_folder!(map, String.t()) :: {map, list} | no_return
  def add_folder!(%BreezeConfig{} = config, name) do
    add_folder(config, name) |> Util.bang_output()
  end

  @spec add_folder(map, String.t(), integer()) :: Client.client_response()
  def add_folder(%BreezeConfig{} = config, name, parent_id),
    do: Client.get_request(config, "tags/add_tag", %{name: name, parent_id: parent_id})

  @spec add_folder!(map, String.t(), integer()) :: {map, list} | no_return
  def add_folder!(%BreezeConfig{} = config, name, parent_id) do
    add_folder(config, name, parent_id) |> Util.bang_output()
  end

  @doc """
  Delete a tag by ID
  """
  @spec delete_tag(map, String.t()) :: Client.client_response()
  def delete_tag(%BreezeConfig{} = config, id),
    do: Client.get_request(config, "tags/delete_tag", %{tag_id: id})

  @spec delete_tag!(map, String.t()) :: {map, list} | no_return
  def delete_tag!(%BreezeConfig{} = config, id) do
    delete_tag(config, id) |> Util.bang_output()
  end

  @doc """
  Delete a folder by ID
  """
  @spec delete_folder(map, String.t()) :: Client.client_response()
  def delete_folder(%BreezeConfig{} = config, id),
    do: Client.get_request(config, "tags/delete_tag_folder", %{folder_id: id})

  @spec delete_folder!(map, String.t()) :: {map, list} | no_return
  def delete_folder!(%BreezeConfig{} = config, id) do
    delete_folder(config, id) |> Util.bang_output()
  end

  @doc """
  Assign a tag to a person.

  Shape of params should be `%{tag_id: tag_id, person_id: person_id}`
  """
  @spec assign(map, map) :: Client.client_response()
  def assign(%BreezeConfig{} = config, params),
    do: Client.get_request(config, "tags/assign", params)

  @spec assign!(map, map) :: {map, list} | no_return
  def assign!(%BreezeConfig{} = config, params) do
    assign(config, params) |> Util.bang_output()
  end

  @doc """
  Remove a tag from a person.

  Shape of params should be `%{tag_id: tag_id, person_id: person_id}`
  """
  @spec unassign(map, map) :: Client.client_response()
  def unassign(%BreezeConfig{} = config, params),
    do: Client.get_request(config, "tags/unassign", params)

  @spec unassign!(map, map) :: {map, list} | no_return
  def unassign!(%BreezeConfig{} = config, params) do
    unassign(config, params) |> Util.bang_output()
  end
end
