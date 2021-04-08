defmodule Exticket.Bookings.Booking do
  @keys [
    :departure_date,
    :return_date,
    :origin,
    :destination,
    :type,
    :price,
    :quantity,
    :passengers,
    :firm
  ]

  @enforce_keys @keys

  @types [:SOMENTE_IDA, :IDA_E_VOLTA]
  @price %{adults: 500, babies: 100, children: 350}

  defstruct @keys

  def build(
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
      when quantity > 0 and type in @types do
    {:ok,
     %__MODULE__{
       departure_date: departure_date,
       return_date: return_date,
       origin: origin,
       destination: destination,
       type: type,
       price: price,
       quantity: quantity,
       passengers: passengers,
       firm: firm
     }}
  end

  def build(_departure_date, _return_date, _origin, _destination, _type, _price, _quantity, _firm) do
    {:error, "Ivalid parameters"}
  end
end
