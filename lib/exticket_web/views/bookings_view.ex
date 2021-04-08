defmodule ExticketWeb.BookingsView do
  alias Exticket.Bookings.Booking

  def render("availability.json", %{
        availabilitys: [%Booking{} | _bookings] = bookings
      }) do
    Enum.map(bookings, &build_booking_josn(&1))
  end

  def render("bookings.json", %{
        bookings: [%Booking{} | _bookings] = bookings
      }) do
    Enum.map(bookings, &build_booking_josn(&1))
  end

  defp build_booking_josn(%Booking{
         departure_date: departure_date,
         destination: destination,
         origin: origin,
         price: price,
         quantity: quantity,
         return_date: return_date,
         type: type,
         passengers: passengers,
         firm: firm
       }) do
    %{
      "booking" => %{
        "departure_date" => Date.to_string(departure_date),
        "return_date" => Date.to_string(return_date),
        "destination" => destination,
        "origin" => origin,
        "passengers" => passengers,
        "type" => Atom.to_string(type)
      },
      "price" => Decimal.to_string(price),
      "quantity" => quantity,
      "firm" => Atom.to_string(firm)
    }
  end
end
