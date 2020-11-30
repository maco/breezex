defmodule Breezex.Event do
  @moduledoc """
  Module implementing the Breeze event API.
  """
  alias Breezex.BreezeConfig
  alias Breezex.Client
  alias Breezex.Util

  @doc """
  List the current month's events
  """
  @spec list(map) :: Client.client_response()
  def list(%BreezeConfig{} = config), do: Client.get_request(config, "events")

  @spec list!(map) :: {map, list} | no_return
  def list!(%BreezeConfig{} = config) do
    list(config) |> Util.bang_output()
  end

  @doc """
  Advanced event search

  The `query` parameter is a map. Available keys:
  * start -- events on or after date. Default first of current month.
  * end -- events on or before date. Default last of current month.
  * category_id -- limit to events on this calendar
  * eligible -- if 1, include details about check-in eligibility ("everyone", "tags", "forms", or "none"). Default 0.
  * details -- if 1, include event details. Default 0.
  * limit -- number of events to return. Default 500. Max 1000.
  """
  @spec list(map, map) :: Client.client_response()
  def list(%BreezeConfig{} = config, query), do: Client.get_request(config, "events", query)

  @spec list!(map, map) :: {map, list} | no_return
  def list!(%BreezeConfig{} = config, query) do
    list(config, query) |> Util.bang_output()
  end

  @doc """
  Show details for one event instance
  """
  @spec show(map, String.t()) :: Client.client_response()
  def show(%BreezeConfig{} = config, id),
    do: Client.get_request(config, "events/list_event", %{instance_id: id})

  @spec show!(map, String.t()) :: {map, list} | no_return
  def show!(%BreezeConfig{} = config, id) do
    show(config, id) |> Util.bang_output()
  end

  @doc """
  List events associated with instance_id

  Params is a map with available keys:
  * shedule_direction -- include events before or after (default "before")
  * schedule_limit -- how many events to return. Default 10. Max 100.
  * eligible -- if 1, include details about check-in eligibility ("everyone", "tags", "forms", or "none"). Default 0.
  * details -- if 1, include event details
  """
  @spec show_series(map, String.t(), map) :: Client.client_response()
  def show_series(%BreezeConfig{} = config, id, params) do
    query_params =
      %{instance_id: id, schedule: 1}
      |> Map.merge(params)

    Client.get_request(config, "events/list_event", query_params)
  end

  @spec show_series!(map, String.t(), map) :: {map, list} | no_return
  def show_series!(%BreezeConfig{} = config, id, params) do
    show_series(config, id, params) |> Util.bang_output()
  end

  @doc """
  List all available calendars
  """

  @spec list_calendars(map) :: Client.client_response()
  def list_calendars(%BreezeConfig{} = config),
    do: Client.get_request(config, "events/calendars/list")

  @spec list_calendars!(map) :: {map, list} | no_return
  def list_calendars!(%BreezeConfig{} = config) do
    list_calendars(config) |> Util.bang_output()
  end

  @doc """
  List all configured locations
  """

  @spec list_locations(map) :: Client.client_response()
  def list_locations(%BreezeConfig{} = config),
    do: Client.get_request(config, "events/locations")

  @spec list_locations!(map) :: {map, list} | no_return
  def list_locations!(%BreezeConfig{} = config) do
    list_locations(config) |> Util.bang_output()
  end

  @doc """
  Adds an event to a Breeze calendar.

  Name and start_time (as a DateTime struct) are required. Optional details include:
  * end_time -- what time the event ends. Default: one hour after start time.
  * all_day -- if 1, ignores the time portion of the start_time DateTime. Default: 0.
  * description -- description of the event on the calendar. HTML is allowed.
  * category_id -- id of the calender it should be put on. Default: 0.
  * event_id -- adds the new event to the series belonging to event_id. Default: create new series.
  """

  @spec add(map, String.t(), DateTime.t(), map) :: Client.client_response()
  def add(%BreezeConfig{} = config, name, start_time, details) do
    start_epoch = DateTime.to_unix(start_time)

    query_params =
      %{name: name, starts_on: start_epoch}
      |> Map.merge(
        case Map.has_key?(details, :end_time) do
          true ->
            {end_time, deets} = Map.pop!(details, :end_time)
            end_epoch = DateTime.to_unix(end_time)
            Map.put(deets, :ends_on, end_epoch)

          false ->
            details
        end
      )

    Client.get_request(config, "events/add", query_params)
  end

  @spec add!(map, String.t(), DateTime.t(), map) :: {map, list} | no_return
  def add!(%BreezeConfig{} = config, name, start_time, details) do
    add(config, name, start_time, details) |> Util.bang_output()
  end

  @doc """
  Delete an event using its ID
  """

  @spec delete(map, String.t()) :: Client.client_response()
  def delete(%BreezeConfig{} = config, id),
    do: Client.get_request(config, "events/delete", %{instance_id: id})

  @spec delete!(map, String.t()) :: {map, list} | no_return
  def delete!(%BreezeConfig{} = config, id) do
    delete(config, id) |> Util.bang_output()
  end

  @doc """
  Check a person into an event.

  Shape of params should be `%{instance_id: instance_id, person_id: person_id}`
  """
  @spec check_in(map, map) :: Client.client_response()
  def check_in(%BreezeConfig{} = config, params),
    do: Client.get_request(config, "events/attendance/add", params)

  @spec check_in!(map, map) :: {map, list} | no_return
  def check_in!(%BreezeConfig{} = config, params) do
    check_in(config, params) |> Util.bang_output()
  end

  @doc """
  Check a person out of an event.

  Shape of params should be `%{instance_id: instance_id, person_id: person_id}`
  """
  @spec check_out(map, map) :: Client.client_response()
  def check_out(%BreezeConfig{} = config, params) do
    query_params = Map.put(params, :direction, "out")
    Client.get_request(config, "events/attendance/add", query_params)
  end

  @spec check_out!(map, map) :: {map, list} | no_return
  def check_out!(%BreezeConfig{} = config, params) do
    check_out(config, params) |> Util.bang_output()
  end

  @doc """
  Remove an attendance record.

  Shape of params should be `%{instance_id: instance_id, person_id: person_id}`
  """
  @spec unrecord(map, map) :: Client.client_response()
  def unrecord(%BreezeConfig{} = config, params),
    do: Client.get_request(config, "events/attendance/delete", params)

  @spec unrecord!(map, map) :: {map, list} | no_return
  def unrecord!(%BreezeConfig{} = config, params) do
    unrecord(config, params) |> Util.bang_output()
  end

  @doc """
  List basic info about everyone who attended an event.
  """
  @spec roster(map, String.t() | Integer) :: Client.client_response()
  def roster(%BreezeConfig{} = config, id),
    do: Client.get_request(config, "events/attendance/list", %{instance_id: id})

  @spec roster!(map, String.t() | Integer) :: {map, list} | no_return
  def roster!(%BreezeConfig{} = config, id) do
    roster(config, id) |> Util.bang_output()
  end

  @doc """
  List detailed info about everyone who attended an event.
  """
  @spec detailed_roster(map, String.t() | Integer) :: Client.client_response()
  def detailed_roster(%BreezeConfig{} = config, id),
    do: Client.get_request(config, "events/attendance/list", %{instance_id: id, details: true})

  @spec detailed_roster!(map, String.t() | Integer) :: {map, list} | no_return
  def detailed_roster!(%BreezeConfig{} = config, id) do
    detailed_roster(config, id) |> Util.bang_output()
  end

  @doc """
  Get an anonymous headcount of event attendance.
  """
  @spec headcount(map, String.t() | Integer) :: Client.client_response()
  def headcount(%BreezeConfig{} = config, id),
    do:
      Client.get_request(config, "events/attendance/list", %{instance_id: id, type: "anonymous"})

  @spec headcount!(map, String.t() | Integer) :: {map, list} | no_return
  def headcount!(%BreezeConfig{} = config, id) do
    headcount(config, id) |> Util.bang_output()
  end

  @doc """
  Get a list of people eligible for check-in
  """
  @spec eligible_people(map, String.t() | Integer) :: Client.client_response()
  def eligible_people(%BreezeConfig{} = config, id),
    do: Client.get_request(config, "events/attendance/eligible", %{instance_id: id})

  @spec eligible_people!(map, String.t() | Integer) :: {map, list} | no_return
  def eligible_people!(%BreezeConfig{} = config, id) do
    eligible_people(config, id) |> Util.bang_output()
  end
end
