defmodule Exticket.Hostings.Search do
  alias Exticket.Hostings.Availability
  alias Exticket.Hostings.Hosting

  def call(params) do
    hotel =
      []
      |> handle_availability(Availability.call(params, :praiano))
      |> handle_availability(Availability.call(params, :pousada))
      |> handle_availability(Availability.call(params, :boateazul))

    {:ok, hotel}
  end

  defp handle_availability(list, {:ok, %Hosting{} = hosting}),
    do: List.insert_at(list, -1, hosting)
end
