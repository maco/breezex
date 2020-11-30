defmodule Breezex.Pledges do
  @moduledoc """
  Module implementing the Breeze pledges API.
  """
  alias Breezex.BreezeConfig
  alias Breezex.Client
  alias Breezex.Util

  @doc """
  List pledge campaigns
  """
  @spec list_campaigns(map) :: Client.client_response()
  def list_campaigns(%BreezeConfig{} = config),
    do: Client.get_request(config, "pledges/list_campaigns")

  @spec list_campaigns!(map) :: {map, list} | no_return
  def list_campaigns!(%BreezeConfig{} = config) do
    list_campaigns(config) |> Util.bang_output()
  end

  @doc """
  List pledges for a given campaign ID
  """
  @spec list_pledges(map, integer()) :: Client.client_response()
  def list_pledges(%BreezeConfig{} = config, id),
    do: Client.get_request(config, "pledges/list_pledges", %{campaign_id: id})

  @spec list_pledges!(map, integer()) :: {map, list} | no_return
  def list_pledges!(%BreezeConfig{} = config, id) do
    list_pledges(config, id) |> Util.bang_output()
  end

  @doc """
  List contributions for a given campaign ID
  """
  @spec list_contributions(map, integer()) :: Client.client_response()
  def list_contributions(%BreezeConfig{} = config, id),
    do: Client.get_request(config, "giving/list", %{pledge_ids: id})

  @spec list_contributions!(map, integer()) :: {map, list} | no_return
  def list_contributions!(%BreezeConfig{} = config, id) do
    list_contributions(config, id) |> Util.bang_output()
  end
end
