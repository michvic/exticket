defmodule ExticketWeb.HostingsView do
  alias Exticket.Hostings.Hosting

  def render("availability.json", %{
        availability: %Hosting{} = hostings
      }) do
    build_hosting_josn(hostings)
  end

  def render("hostings.json", %{
        hostings: [%Hosting{} | _bookings] = hostings
      }) do
    Enum.map(hostings, &build_hosting_josn(&1))
  end

  defp build_hosting_josn(%Hosting{
         departure_date: departure_date,
         return_date: return_date,
         destination: destination,
         bedrooms_number: bedrooms_number,
         price: price,
         stay: stay,
         firm: firm,
         guests: guests
       }) do
    %{
      "hosting" => %{
        "departure_date" => Date.to_string(departure_date),
        "return_date" => Date.to_string(return_date),
        "destination" => destination,
        "bedrooms_number" => bedrooms_number
      },
      "price" => Decimal.to_string(price),
      "stay" => stay,
      "firm" => firm,
      "guests" => guests
    }
  end
end
