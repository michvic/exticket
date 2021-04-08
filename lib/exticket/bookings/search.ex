defmodule Exticket.Bookings.Search do
  alias Exticket.Bookings.Availability
  alias Exticket.Bookings.Booking

  def call(params) do
    flight =
      []
      |> handle_availability(Availability.call(params, :azul))
      |> handle_availability(Availability.call(params, :tam))
      |> handle_availability(Availability.call(params, :gol))

    {:ok, flight}
  end

  defp handle_availability(list, {:ok, %Booking{} = booking}),
    do: List.insert_at(list, -1, booking)
end
