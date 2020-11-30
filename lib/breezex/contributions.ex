defmodule Breezex.Contributions do
  @moduledoc """
  Module implementing the Breeze contributions API.
  """
  alias Breezex.BreezeConfig
  alias Breezex.Client
  alias Breezex.Util

  @doc """
  List the contributions greater than or equal to a certain amount
  """
  @spec over_amount(map, integer()) :: Client.client_response()
  def over_amount(%BreezeConfig{} = config, amount),
    do: Client.get_request(config, "giving/list", %{amount_min: amount})

  @spec over_amount!(map, integer()) :: {map, list} | no_return
  def over_amount!(%BreezeConfig{} = config, amount) do
    over_amount(config, amount) |> Util.bang_output()
  end

  @doc """
  List the contributions less than or equal to a certain amount
  """
  @spec under_amount(map, integer()) :: Client.client_response()
  def under_amount(%BreezeConfig{} = config, amount),
    do: Client.get_request(config, "giving/list", %{amount_max: amount})

  @spec under_amount!(map, integer()) :: {map, list} | no_return
  def under_amount!(%BreezeConfig{} = config, amount) do
    under_amount(config, amount) |> Util.bang_output()
  end

  @doc """
  List the contributions by a person denoted by ID
  """
  @spec by_person(map, integer()) :: Client.client_response()
  def by_person(%BreezeConfig{} = config, id),
    do: Client.get_request(config, "giving/list", %{person_id: id})

  @spec by_person!(map, integer()) :: {map, list} | no_return
  def by_person!(%BreezeConfig{} = config, id) do
    by_person(config, id) |> Util.bang_output()
  end

  @doc """
  List the contributions for pledge campaigns
  """
  @spec for_pledge_campaign(map, [integer()]) :: Client.client_response()
  def for_pledge_campaign(%BreezeConfig{} = config, ids) do
    id_list = Enum.join(ids, "-")
    Client.get_request(config, "giving/list", %{person_id: id_list})
  end

  @spec for_pledge_campaign!(map, [integer()]) :: {map, list} | no_return
  def for_pledge_campaign!(%BreezeConfig{} = config, ids) do
    for_pledge_campaign(config, ids) |> Util.bang_output()
  end

  @doc """
  Contribution advanced search.

  Accepts a map of search filters. Available keys are:
  * start -- contributions on or after date, Date or DateTime object
  * end -- contributions on or before date, Date or DateTime object
  * person_id -- ID of person's contributions to fetch
  * include_family -- boolean. include family members of person_id. Ignored if no person_id provided.
  * min -- amount is greater than or equal
  * max -- amount is less than or equal
  * method_ids -- list of method IDs
  * fund_ids -- list of fund IDs
  * envelope -- envelope number
  * batches -- list of batch numbers
  * forms -- list of form IDs
  * pledge_ids -- list of pledge campaign IDs
  """
  @spec advanced_search(map, map) :: Client.client_response()
  def advanced_search(%BreezeConfig{} = config, params) do
    query_params =
      Enum.reduce(params, %{}, fn
        {:start, date}, qp ->
          Map.put(qp, :start, Util.date_to_DDMMYYYY(date))

        {:end, date}, qp ->
          Map.put(qp, :end, Util.date_to_DDMMYYYY(date))

        {:person_id, id}, qp ->
          Map.put(qp, :person_id, id)

        {:include_family, val}, qp ->
          bool =
            case val do
              true -> 1
              false -> 0
            end

          Map.put(qp, :include_family, bool)

        {:min, amount}, qp ->
          Map.put(qp, :amount_min, amount)

        {:max, amount}, qp ->
          Map.put(qp, :amount_max, amount)

        {:method_ids, ids}, qp ->
          id_list = Enum.join(ids, "-")
          Map.put(qp, :method_ids, id_list)

        {:fund_ids, ids}, qp ->
          id_list = Enum.join(ids, "-")
          Map.put(qp, :fund_ids, id_list)

        {:envelope, num}, qp ->
          Map.put(qp, :envelope_number, num)

        {:batches, ids}, qp ->
          id_list = Enum.join(ids, "-")
          Map.put(qp, :batches, id_list)

        {:forms, ids}, qp ->
          id_list = Enum.join(ids, "-")
          Map.put(qp, :forms, id_list)

        {:pledge_ids, ids}, qp ->
          id_list = Enum.join(ids, "-")
          Map.put(qp, :pledge_ids, id_list)
      end)

    Client.get_request(config, "giving/list", query_params)
  end

  @spec advanced_search!(map, map) :: {map, list} | no_return
  def advanced_search!(%BreezeConfig{} = config, params) do
    advanced_search(config, params) |> Util.bang_output()
  end

  @doc """
  Add a contribution record.

  Valid keys for params map:
  * date -- Date or DateTime
  * person_id -- donor's Breeze ID. If unknown, use `person` or `uid` instead
  * person -- struct including at least `name` and `email` or `street_adress` to be matched against Breeze DB
  * uid -- unique ID provided by giving platform (which must be provided as `processor`)
  * processor -- name of payment processor. Needed if using `uid`
  * method -- payment method (check, cash, credit/debit online, credit/debit offline, donated goods, stock, direct deposit)
  * funds -- struct for how to split donation `%{name: "", amount: 123, id: "123"}`. ID is optional and will take precedence over name.
  * amount -- total donated. Must match total of what's in `funds`
  * group -- all contributions with matching group numbers will be a single batch, so should be unique per batch. Will auto-increment to the next batch in series.
  * batch_number -- batch number to import into
  * batch_name -- name of the batch. Can be paired with either `batch_number` or `group`
  * note -- optional note about contribution
  """
  @spec add(map, map) :: Client.client_response()
  def add(%BreezeConfig{} = config, params) do
    query_params = format_params(params)
    Client.get_request(config, "giving/add", query_params)
  end

  @spec add!(map, map) :: {map, list} | no_return
  def add!(%BreezeConfig{} = config, params) do
    add(config, params) |> Util.bang_output()
  end

  @doc """
  Edit a contribution record. Requires a payment ID. Params are as in `add/2`
  """
  @spec edit(map, integer(), map) :: Client.client_response()
  def edit(%BreezeConfig{} = config, id, params) do
    query_params = %{payment_id: id} |> Map.merge(format_params(params))
    Client.get_request(config, "giving/edit", query_params)
  end

  @spec edit!(map, integer(), map) :: {map, list} | no_return
  def edit!(%BreezeConfig{} = config, id, params) do
    edit(config, id, params) |> Util.bang_output()
  end

  @doc """
  Delete a contribution record by ID
  """
  @spec delete(map, integer()) :: Client.client_response()
  def delete(%BreezeConfig{} = config, id),
    do: Client.get_request(config, "giving/delete", %{payment_id: id})

  @spec delete!(map, integer()) :: {map, list} | no_return
  def delete!(%BreezeConfig{} = config, id) do
    delete(config, id) |> Util.bang_output()
  end

  @doc """
  View a contribution record by ID
  """
  @spec view(map, integer()) :: Client.client_response()
  def view(%BreezeConfig{} = config, id),
    do: Client.get_request(config, "giving/view", %{payment_id: id})

  @spec view!(map, integer()) :: {map, list} | no_return
  def view!(%BreezeConfig{} = config, id) do
    view(config, id) |> Util.bang_output()
  end

  @doc """
  List funds
  """
  @spec list_funds(map) :: Client.client_response()
  def list_funds(%BreezeConfig{} = config),
    do: Client.get_request(config, "funds/list", %{include_totals: 0})

  @spec list_funds!(map) :: {map, list} | no_return
  def list_funds!(%BreezeConfig{} = config) do
    list_funds(config) |> Util.bang_output()
  end

  @doc """
  List funds with totals
  """
  @spec list_funds_with_totals(map) :: Client.client_response()
  def list_funds_with_totals(%BreezeConfig{} = config),
    do: Client.get_request(config, "funds/list", %{include_totals: 1})

  @spec list_funds_with_totals!(map) :: {map, list} | no_return
  def list_funds_with_totals!(%BreezeConfig{} = config) do
    list_funds_with_totals(config) |> Util.bang_output()
  end

  defp format_params(params) do
    params =
      case Map.pop(params, :date) do
        {nil, params} ->
          params

        {date, params} ->
          Map.put(params, :date, Util.date_to_DDMMYYYY(date))
      end

    params =
      case Map.pop(params, :person) do
        {nil, params} ->
          params

        {person, params} ->
          person_json = Poison.encode!(person)
          Map.put(params, :person_json, person_json)
      end

    params =
      case Map.pop(params, :funds) do
        {nil, params} ->
          params

        {funds, params} ->
          funds_json = Poison.encode!(funds)
          Map.put(params, :funds_json, funds_json)
      end

    params
  end
end
