defmodule Exticket.Hostings.Agent do
  use Agent

  alias Exticket.Hostings.Hosting

  def start_agent(_initial_value), do: Agent.start_link(fn -> %{} end, name: __MODULE__)

  def save(%Hosting{} = hosting) do
    uuid = UUID.uuid4()

    Agent.update(__MODULE__, &update_state(&1, hosting, uuid))

    {:ok, uuid}
  end

  def get(id), do: Agent.get(__MODULE__, &get_hosting(&1, id))

  def list_all, do: Agent.get(__MODULE__, & &1)

  defp update_state(state, %Hosting{} = hosting, uuid), do: Map.put(state, uuid, hosting)

  defp get_hosting(state, id) do
    case Map.get(state, id) do
      nil -> {:error, "flight booking not found"}
      hosting -> {:ok, hosting}
    end
  end
end
