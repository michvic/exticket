defmodule ExticketWeb.WellcomeController do
  use ExticketWeb, :controller

  def index(conn, params) do
    conn
    |> put_status(:ok)
    |> json(%{
      "message" => "Wellcome ExTicket"
    })
  end
end
