defmodule Exticket.Bookings.Agent do
  use Agent

  alias Exticket.Bookings.Booking

  def start_agent(_initial_value), do: Agent.start_link(fn -> %{} end, name: __MODULE__)

  def save(%Booking{} = booking) do
    uuid = UUID.uuid4()

    Agent.update(__MODULE__, &update_state(&1, booking, uuid))

    {:ok, uuid}
  end

  def get(id), do: Agent.get(__MODULE__, &get_booking(&1, id))

  def list_all, do: Agent.get(__MODULE__, & &1)

  defp update_state(state, %Booking{} = booking, uuid), do: Map.put(state, uuid, booking)

  defp get_booking(state, id) do
    case Map.get(state, id) do
      nil -> {:error, "flight booking not found"}
      booking -> {:ok, booking}
    end
  end
end
