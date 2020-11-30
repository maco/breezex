defmodule Breezex.Client do
  @moduledoc """
  Client responsible for making requests to Breeze and handling the responses.
  """

  # Some of this is based on lob-elixir, which is copyright Lob.com

  alias Poison.Parser
  alias HTTPoison.Error
  alias HTTPoison.Response

  use HTTPoison.Base

  @type client_response :: {:ok, map, list} | {:error, map}

  # #########################
  # HTTPoison.Base callbacks
  # #########################

  def process_response_body(body) do
    Parser.parse!(body, %{keys: :atoms})
  end

  # #########################
  # Client API
  # #########################
  @doc """
  Make a GET request against the Breeze API
  """
  @spec get_request(map, String.t(), map) :: client_response
  def get_request(config, endpoint, params \\ %{}) do
    %{breeze_host: breeze_host, api_key: api_key} = config
    headers = %{"Api-key" => api_key}
    url = "https://#{breeze_host}/api/#{endpoint}/"

    query_string = URI.encode_query(params)
    query_string = Regex.replace(~r/^([\w])/, query_string, "?\\g{1}")

    (url <> query_string)
    |> get(headers)
    |> handle_response
  end

  # #########################
  # Response handlers
  # #########################

  @spec handle_response({:ok | :error, Response.t() | Error.t()}) :: client_response
  defp handle_response({:ok, %{body: body, headers: headers, status_code: code}})
       when code >= 200 and code < 300 do
    {:ok, body, headers}
  end

  defp handle_response({:ok, %{body: body}}) do
    {:error, body.error}
  end

  defp handle_response({:error, error = %Error{}}) do
    {:error, %{message: Error.message(error)}}
  end
end
