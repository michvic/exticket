defmodule Exticket do
  alias Exticket.Bookings.Create, as: BookingsCreate
  alias Exticket.Bookings.Search, as: BookingsAvailability
  alias Exticket.Bookings.Show, as: BookingsShow

  alias Exticket.Hostings.Create, as: HostingsCreate
  alias Exticket.Hostings.Search, as: HostingsAvailability
  alias Exticket.Hostings.Show, as: HostingsShow

  defdelegate availability_bookings(params), to: BookingsAvailability, as: :call
  defdelegate create_bookings(params), to: BookingsCreate, as: :call
  defdelegate show_bookings(params), to: BookingsShow, as: :call

  defdelegate availability_hostings(params), to: HostingsAvailability, as: :call
  defdelegate create_hostings(params), to: HostingsCreate, as: :call
  defdelegate show_hostings(params), to: HostingsShow, as: :call
end
