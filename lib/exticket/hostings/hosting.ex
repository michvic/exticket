defmodule Exticket.Hostings.Hosting do
  @keys [
    :departure_date,
    :return_date,
    :destination,
    :bedrooms_number,
    :price,
    :stay,
    :firm,
    :guests
  ]

  @enforce_keys @keys

  @price %{adults: 50, babies: 0, children: 25, daily: 100}

  @hotels %{praiano: 1.2, pousada: 1.5, boateazul: 1.6}
  @firm [:praiano, :pousada, :boateazul]

  defstruct @keys

  def build(
        departure_date,
        return_date,
        destination,
        bedrooms_number,
        stay,
        firm,
        guests:
          %{
            adults: adults,
            babies: babies,
            children: children
          } = guests
      )
      when stay > 0 and bedrooms_number > 0 and firm in @firm do
    {:ok,
     %__MODULE__{
       departure_date: departure_date,
       return_date: return_date,
       destination: destination,
       bedrooms_number: bedrooms_number,
       price: calculate_price(adults, children, babies, bedrooms_number, stay, firm),
       firm: firm,
       stay: stay,
       guests: guests
     }}
  end

  def build(_departure_date, _return_date, _origin, _destination, _type, _price, _quantity) do
    {:error, "Ivalid parameters"}
  end

  defp calculate_price(adults, children, babies, bedrooms_number, stay, firm) do
    bedrooms_number
    |> Decimal.mult(@price.daily)
    |> Decimal.mult(stay)
    |> Decimal.add(Decimal.mult(adults, @price.adults))
    |> Decimal.add(Decimal.mult(children, @price.children))
    |> Decimal.add(Decimal.mult(babies, @price.babies))
    |> Decimal.mult(Decimal.from_float(@hotels[firm]))
  end

  # defp calculate_people(adults, children, babies) do
  #   adults
  #   |> Decimal.new()
  #   |> Decimal.add(children)
  #   |> Decimal.add(babies)
  # end
end
