defmodule Exticket.Bookings.Show do
  alias Exticket.Bookings.Agent, as: BookingAgent
  alias Exticket.Bookings.Booking

  def call(%{"from_date" => from_date, "to_date" => to_date}) do
    BookingAgent.start_agent(%{})
    build_bookings_list(from_date, to_date)
  end

  defp build_bookings_list(from_date, to_date) do
    {:ok, from_date} = Date.from_iso8601(from_date)
    {:ok, to_date} = Date.from_iso8601(to_date)

    list =
      BookingAgent.list_all()
      |> Map.values()
      |> Enum.reduce([], &filter_bookings(&1, &2, from_date, to_date))

    case List.first(list) do
      nil -> {:error, "The hosting list is empty"}
      _firt -> {:ok, list}
    end
  end

  defp filter_bookings(
         %Booking{
           departure_date: departure_date,
           return_date: return_date
         } = booking,
         acc,
         from_date,
         to_date
       ) do
    with :lt <- Date.compare(from_date, departure_date),
         :gt <- Date.compare(to_date, return_date) do
      [booking | acc]
    else
      _ ->
        nil
    end
  end
end
