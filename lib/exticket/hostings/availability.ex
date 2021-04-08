defmodule Exticket.Hostings.Availability do
  alias Exticket.Hostings.Hosting

  def call(
        %{
          "guests" => %{
            "adults" => adults,
            "babies" => babies,
            "children" => children
          },
          "departure_date" => departure_date,
          "return_date" => return_date,
          "destination" => destination,
          "bedrooms_number" => bedrooms_number
        },
        firm
      ) do
    {:ok, departure_date} = Date.from_iso8601(departure_date)
    {:ok, return_date} = Date.from_iso8601(return_date)
    bedrooms_number = String.to_integer(bedrooms_number)

    departure_date
    |> date_is_valid?(return_date)
    |> handle_build_booking(
      departure_date,
      return_date,
      destination,
      bedrooms_number,
      adults,
      babies,
      children,
      firm
    )
  end

  defp date_is_valid?(departure_date, return_date) do
    case Date.compare(departure_date, return_date) do
      :lt -> {:ok, stay: Date.diff(return_date, departure_date)}
      :eq -> {:ok, stay: 1}
      _ -> {:error, "Date is invalid"}
    end
  end

  defp handle_build_booking(
         {:ok, stay: stay},
         departure_date,
         return_date,
         destination,
         bedrooms_number,
         adults,
         babies,
         children,
         firm
       ) do
    Hosting.build(
      departure_date,
      return_date,
      destination,
      bedrooms_number,
      stay,
      firm,
      guests: %{adults: adults, babies: babies, children: children}
    )
  end

  defp handle_build_booking(
         {:error, _reason} = error,
         _departure_date,
         _return_date,
         _destination,
         _bedrooms_number,
         _adults,
         _babies,
         _children,
         _firm
       ),
       do: error
end
