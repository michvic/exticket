defmodule ExticketWeb.HostingsController do
  use ExticketWeb, :controller

  alias Exticket.Hostings.Hosting

  def create(conn, params) do
    with {:ok, uuid} <- Exticket.create_hostings(params) do
      conn
      |> put_status(:created)
      |> json(%{
        message: "Hosting done",
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
    with {:ok, [%Hosting{} | _tail] = hostings} <- Exticket.show_hostings(params) do
      conn
      |> put_status(:ok)
      |> render("hostings.json", hostings: hostings)
    else
      {:error, reason} ->
        conn
        |> put_status(:bad_request)
        |> json(%{message: reason})
    end
  end

  def index(conn, params) do
    with {:ok, [%Hosting{} | _tail] = availability} <- Exticket.availability_hostings(params) do
      conn
      |> put_status(:ok)
      |> render("hostings.json", hostings: availability)
    else
      {:error, reason} ->
        conn
        |> put_status(:bad_request)
        |> json(%{message: reason})
    end
  end
end
