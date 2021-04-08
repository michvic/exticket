defmodule ExticketWeb.BookingsController do
  use ExticketWeb, :controller

  alias Exticket.Bookings.Booking

  def create(conn, params) do
    with {:ok, uuid} <- Exticket.create_bookings(params) do
      conn
      |> put_status(:created)
      |> json(%{
        message: "Air tickets from purchased",
        id: uuid
      })
    else
      {:error, reason} ->
        conn
        |> put_status(:bad_request)
        |> json(%{message: reason})
    end
  end

  def shows(conn, params) do
    with {:ok, [%Booking{} | _tail] = bookings} <- Exticket.show_bookings(params) do
      conn
      |> put_status(:ok)
      |> render("bookings.json", bookings: bookings)
    else
      {:error, reason} ->
        conn
        |> put_status(:bad_request)
        |> json(%{message: reason})
    end
  end

  def index(conn, params) do
    with {:ok, [%Booking{} | _tail] = availabilitys} <- Exticket.availability_bookings(params) do
      conn
      |> put_status(:ok)
      |> render("availability.json", availabilitys: availabilitys)
    else
      {:error, reason} ->
        conn
        |> put_status(:bad_request)
        |> json(%{message: reason})
    end
  end
end
