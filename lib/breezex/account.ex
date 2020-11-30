defmodule Breezex.Account do
  @moduledoc """
  Module implementing the Breeze account API.
  """
  alias Breezex.BreezeConfig
  alias Breezex.Client
  alias Breezex.Util

  @doc """
  Get information about your account
  """
  @spec summary(map) :: Client.client_response()
  def summary(%BreezeConfig{} = config),
    do: Client.get_request(config, "account/summary")

  @spec summary!(map) :: {map, list} | no_return
  def summary!(%BreezeConfig{} = config) do
    summary(config) |> Util.bang_output()
  end

  @doc """
  Query audit log using a map containing filters.

  Valid keys:
  * action -- see https://app.breezechms.com/api#list_account_log for valid values
  * start_date -- Date or DateTime
  * end_date -- Date or DateTime
  * user_id -- ID of user who did the action
  * details -- Boolean. Should details be included?
  * limit -- number of log entries to return. Max is 3000. Default is 500.
  """
  @spec audit_log(map, map) :: Client.client_response()
  def audit_log(%BreezeConfig{} = config, filter) do
    query_params =
      Enum.reduce(filter, %{}, fn
        {:action, action}, qp ->
          Map.put(qp, :action, action)

        {:user_id, user_id}, qp ->
          Map.put(qp, :user_id, user_id)

        {:limit, limit}, qp ->
          Map.put(qp, :limit, limit)

        {:start_date, date}, qp ->
          Map.put(qp, :start, Util.date_to_YYYYMMDD(date))

        {:end_date, date}, qp ->
          Map.put(qp, :end, Util.date_to_YYYYMMDD(date))

        {:details, val}, qp ->
          bool =
            case val do
              true -> 1
              false -> 0
            end

          Map.put(qp, :details, bool)
      end)

    Client.get_request(config, "account/list_log", query_params)
  end

  @spec audit_log!(map, map) :: {map, list} | no_return
  def audit_log!(%BreezeConfig{} = config, filter) do
    audit_log(config, filter) |> Util.bang_output()
  end
end
