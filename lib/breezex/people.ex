defmodule Breezex.People do
  @moduledoc """
  Module implementing the Breeze people API.
  """
  alias Breezex.BreezeConfig
  alias Breezex.Client
  alias Breezex.Util

  @doc """
    Returns all names and IDs in Breeze
  """

  @spec list(map) :: Client.client_response()
  def list(%BreezeConfig{} = config), do: Client.get_request(config, "people")

  @spec list!(map) :: {map, list} | no_return
  def list!(%BreezeConfig{} = config) do
    list(config) |> Util.bang_output()
  end

  @doc """
  Returns a list of people, paginated based on options, and filtered based on filter.

  Options is a map of shape
  ```
  %{
    details: 1,
    limit: 50,
    offset: 0
  }
  When details is 1 (default), just get names. When 0, get all data (slower).
  Limit and offset are for pagination. Both default to 0. With no limit or 0, all people are returned.

  Filter is a map. The keys are profile field IDs. The values are the values to search for.
  ```
  """

  @spec list(map, map, map) :: Client.client_response()
  def list(%BreezeConfig{} = config, options, filter) do
    filter_json = Poison.encode!(filter)
    query_params = Map.put(options, :filter_json, filter_json)
    Client.get_request(config, "people", query_params)
  end

  @spec list!(map, map, map) :: {map, list} | no_return
  def list!(%BreezeConfig{} = config, options, params) do
    list(config, options, params) |> Util.bang_output()
  end

  @doc """
  Show a person by ID
  """
  @spec show(Breezex.Map, any) :: {:error, map} | {:ok, map, [any]}
  def show(%BreezeConfig{} = config, id), do: Client.get_request(config, "people/#{id}")

  @spec show!(Breezex.Map, any) :: {any, any}
  def show!(%BreezeConfig{} = config, id) do
    show(config, id) |> Util.bang_output()
  end

  @doc """
  List all profile fields that have been configured in Breeze.

  The most useful thing in the output is going to be the `field_id` (since it's used in querying and updating people) and `name`.
  With those two, you can find a field and query on it.
  """
  @spec list_profile_fields(map) :: Client.client_response()
  def list_profile_fields(%BreezeConfig{} = config),
    do: Client.get_request(config, "profile")

  @spec list_profile_fields!(map) :: {map, list} | no_return
  def list_profile_fields!(%BreezeConfig{} = config) do
    list_profile_fields(config) |> Util.bang_output()
  end

  @doc """
  Add a person to Breeze.

  First and last names are required. Other fields can be included in a map where field IDs are keys.
  """
  @spec add(map, String.t(), String.t(), map | nil) :: Client.client_response()
  def add(%BreezeConfig{} = config, first, last, params \\ %{}) do
    fields = Poison.encode!(params)
    query_params = %{first: first, last: last, fields_json: fields}
    Client.get_request(config, "people/add", query_params)
  end

  @spec add!(map, String.t(), String.t(), map | nil) :: {map, list} | no_return
  def add!(%BreezeConfig{} = config, first, last, params \\ %{}) do
    add(config, first, last, params) |> Util.bang_output()
  end

  @doc """
  Update a person.

  The person's ID is required. For the params, pass in a list of structs. Most structs should have
  the shape `%{field_id: field_id, field_type: field_type, response: new_value}`. All values are strings.

  Field type options are:
  * text
  * radio -- used for both multiple choice and dropdown
  * checkbox
  * date -- formatted `MM/DD/YYYY`
  * textarea
  * birthdate -- format `MM/DD/YYYY`
  *

  Special structs:
  Email:
  ```
  %{
    field_id: "",
    field_type: "email",
    response: true,
    details: %{address: ""}
  }
  ```

  Phones:
  ```
  %{
    field_id: "",
    field_type: "phone",
    response: true,
    details: %{phone_mobile: ""} # or `phone_home` or `phone_work`
  }
  ```

  Address:
  ```
  %{
    field_id: "",
    field_type: "address",
    response: true,
    details: %{
      street_addres: "",
      city: "",
      state: "", # 2-letter abbreviation
      zip: ""
    }
  }
  ```

  Family role:
  ```
  %{
    field_id: "",
    field_type: "family_role",
    response: undefined,
    details: [
      person_id: 123,
      role_id: 1
    ]
  }
  ```
  Note: role_id is numeric and can be 1 (Unassigned), 2 (Child), 3 (Adult), 4 (Head of Household), or 5 (Spouse)
  """
  @spec update(Breezex.Map, any, list) :: {:error, map} | {:ok, map, [any]}
  def update(%BreezeConfig{} = config, id, params) do
    fields = Poison.encode!(params)
    query_params = %{person_id: id, fields_json: fields}
    Client.get_request(config, "people/update", query_params)
  end

  @spec update!(map, String.t(), list) :: {map, list} | no_return
  def update!(%BreezeConfig{} = config, id, params) do
    update(config, id, params) |> Util.bang_output()
  end

  @doc """
  Delete a person by ID
  """
  @spec delete(map, String.t()) :: Client.client_response()
  def delete(%BreezeConfig{} = config, id),
    do: Client.get_request(config, "people/delete", %{person_id: id})

  @spec delete!(map, String.t()) :: {map, list} | no_return
  def delete!(%BreezeConfig{} = config, id) do
    delete(config, id) |> Util.bang_output()
  end
end
