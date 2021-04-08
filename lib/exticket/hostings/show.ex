defmodule Exticket.Hostings.Show do
  alias Exticket.Hostings.Agent, as: HostingAgent
  alias Exticket.Hostings.Hosting

  def call(%{"from_date" => from_date, "to_date" => to_date}) do
    HostingAgent.start_agent(%{})
    build_hosting_list(from_date, to_date)
  end

  defp build_hosting_list(from_date, to_date) do
    {:ok, from_date} = Date.from_iso8601(from_date)
    {:ok, to_date} = Date.from_iso8601(to_date)

    list =
      HostingAgent.list_all()
      |> Map.values()
      |> Enum.reduce([], &filter_hostings(&1, &2, from_date, to_date))

    case List.first(list) do
      nil -> {:error, "The hosting list is empty"}
      _firt -> {:ok, list}
    end
  end

  defp filter_hostings(
         %Hosting{
           departure_date: departure_date,
           return_date: return_date
         } = hosting,
         acc,
         from_date,
         to_date
       ) do
    with :lt <- Date.compare(from_date, departure_date),
         :gt <- Date.compare(to_date, return_date) do
      [hosting | acc]
    else
      _ ->
        []
    end
  end
end
