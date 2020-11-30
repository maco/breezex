defmodule Breezex.Util do
  @moduledoc """
  Module responsible for transforming arguments for requests.
  """

  @spec bang_output({:ok, any, any}) :: {any, any}
  @doc """
  Unwraps request responses, raising if there's an error
  """
  def bang_output({:ok, body, headers}), do: {body, headers}
  def bang_output({:error, error}), do: raise(to_string(error))

  @doc """
  Returns a string of format "YYYY-MM-DD" for a date

  ## Example

      iex> Breezex.Util.date_to_DDMMYYYY(%Date{day: 3, month: 5, year: 2018})
      "2018-05-03"
  """
  @spec date_to_YYYYMMDD(Date | DateTime) :: String.t()
  def date_to_YYYYMMDD(date) do
    day = Integer.to_string(date.day) |> String.pad_leading(2, "0")
    month = Integer.to_string(date.month) |> String.pad_leading(2, "0")
    year = Integer.to_string(date.year) |> String.pad_leading(4, "0")
    "#{year}-#{month}-#{day}"
  end

  @doc ~S"""
  Returns a string of format "DD-MM-YYYY" for a date

  ## Example

      iex> Breezex.Util.date_to_DDMMYYYY(%Date{day: 3, month: 5, year: 2018})
      "03-05-2018"
  """
  @spec date_to_DDMMYYYY(Date | DateTime) :: String.t()
  def date_to_DDMMYYYY(date) do
    day = Integer.to_string(date.day) |> String.pad_leading(2, "0")
    month = Integer.to_string(date.month) |> String.pad_leading(2, "0")
    year = Integer.to_string(date.year) |> String.pad_leading(4, "0")
    "#{day}-#{month}-#{year}"
  end

  # Below is copied and slightly modified from lob-elixir

  @doc """
  Transforms a map of request params to a URL encoded query string.

  ## Example
      iex> Breezex.Util.build_query_string(%{count: 1, person_id: 5})
      "?count=1&person_id=5"
  """
  @spec build_query_string(map) :: String.t()
  def build_query_string(params) when is_map(params) do
    query_string =
      params
      |> Enum.reduce([], &(&2 ++ transform_argument(&1)))
      |> URI.encode_query()

    case query_string do
      "" ->
        ""

      _ ->
        "?" <> query_string
    end
  end

  @spec transform_argument({any, any}) :: list
  defp transform_argument({:merge_variables, v}), do: transform_argument({"merge_variables", v})

  defp transform_argument({"merge_variables", v}) do
    [{"merge_variables", Poison.encode!(v), [{"Content-Type", "application/json"}]}]
  end

  defp transform_argument({k, v}) when is_list(v) do
    Enum.map(v, fn e ->
      {"#{to_string(k)}[]", to_string(e)}
    end)
  end

  # For context on the format of the struct see:
  # https://github.com/benoitc/hackney/issues/292
  defp transform_argument({k, %{local_path: file_path}}) do
    [{:file, file_path, {"form-data", [name: to_string(k), filename: file_path]}, []}]
  end

  defp transform_argument({k, v}) when is_map(v) do
    Enum.map(v, fn {sub_k, sub_v} ->
      {"#{to_string(k)}[#{to_string(sub_k)}]", to_string(sub_v)}
    end)
  end

  defp transform_argument({k, v}) do
    [{to_string(k), to_string(v)}]
  end
end
