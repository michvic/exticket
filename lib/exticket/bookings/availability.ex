defmodule Exticket.Bookings.Availability do
  alias Exticket.Bookings.Booking

  @flight %{tam: 1.2, azul: 1.5, gol: 1.6}
  @firm [:tam, :azul, :gol]
  @types [:SOMENTE_IDA, :IDA_E_VOLTA]
  @price %{adults: 500, babies: 100, children: 350}

  def call(
        %{
          "passengers" =>
            %{
              "adults" => adults,
              "babies" => babies,
              "children" => children
            } = passengers,
          "departure_date" => departure_date,
          "return_date" => return_date,
          "destination" => destination,
          "origin" => origin,
          "type" => type
        },
        firm
      ) do
    {:ok, departure_date} = Date.from_iso8601(departure_date)
    {:ok, return_date} = Date.from_iso8601(return_date)
    type = String.to_atom(type)
    adults = String.to_integer(adults)
    babies = String.to_integer(babies)
    children = String.to_integer(children)

    departure_date
    |> date_is_valid?(return_date)
    |> assess_bookings(type, adults, children, babies, firm)
    |> handle_build_booking(
      departure_date,
      return_date,
      origin,
      destination,
      type,
      passengers,
      firm
    )
  end

  defp date_is_valid?(departure_date, return_date) do
    case Date.compare(departure_date, return_date) do
      :lt -> :ok
      :eq -> :ok
      _ -> :error
    end
  end

  defp assess_bookings(:ok, type, adults, children, babies, firm)
       when adults >= 0 and children >= 0 and babies >= 0 and type in @types and firm in @firm do
    case type do
      :SOMENTE_IDA ->
        price = calculate_price(adults, children, babies, firm)
        quantity = adults + children + babies
        {:ok, price: price, quantity: quantity}

      :IDA_E_VOLTA ->
        price = Decimal.mult(calculate_price(adults, children, babies, firm), 2)
        quantity = adults + children + babies
        {:ok, price: price, quantity: quantity * 2}

      nil ->
        {:error, "Error flight booking parameters"}
    end
  end

  defp assess_bookings(:error, _type, _adults, _children, _babies, _firm),
    do: {:error, "Date is invalid"}

  defp assess_bookings(:ok, _type, _adults, _children, _babies, _firm),
    do: {:error, "Params is invalid"}

  defp calculate_price(adults, children, babies, firm) do
    Decimal.new(@price.adults)
    |> Decimal.mult(adults)
    |> Decimal.add(Decimal.mult(@price.children, children))
    |> Decimal.add(Decimal.mult(@price.babies, babies))
    |> Decimal.mult(Decimal.from_float(@flight[firm]))
  end

  defp handle_build_booking(
         {:ok, price: price, quantity: quantity},
         departure_date,
         return_date,
         origin,
         destination,
         type,
         passengers,
         firm
       ) do
    Booking.build(
      departure_date,
      return_date,
      origin,
      destination,
      type,
      price,
      quantity,
      passengers,
      firm
    )
  end

  defp handle_build_booking(
         {:error, _reason} = error,
         _departure_date,
         _return_date,
         _origin,
         _destination,
         _type,
         _passengers,
         _firm
       ),
       do: error
end
