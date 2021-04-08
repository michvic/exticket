defmodule Exticket.Hostings.Create do
  alias Exticket.Hostings.Agent, as: HostingAgent
  alias Exticket.Hostings.{Availability, Hosting}

  def call(
        %{
          "credit_card" => %{
            "card_number" => _credit_card,
            "cvv" => _cvv,
            "expiration_date" => _expiration_date,
            "installment_plan" => _installment_plan,
            "owner_name" => _owner_name
          },
          "guests" => %{
            "adults" => _adults,
            "babies" => _babies,
            "children" => _children
          },
          "departure_date" => _departure_date,
          "return_date" => _return_date,
          "destination" => _destination,
          "bedrooms_number" => _bedrooms_number,
          "firm" => firm
        } = params
      ) do
    params
    |> handle_valid_card()
    |> handle_availability(firm)
    |> handle_save()
  end

  defp handle_save({:ok, %Hosting{} = hosting}) do
    HostingAgent.start_agent(%{})
    HostingAgent.save(hosting)
  end

  defp handle_save({:error, _reason} = error), do: error

  defp handle_valid_card(
         %{
           "credit_card" => %{
             "card_number" => credit_card,
             "cvv" => _cvv,
             "expiration_date" => _expiration_date,
             "installment_plan" => installment_plan,
             "owner_name" => _owner_name
           }
         } = params
       )
       when installment_plan <= 6 and is_integer(credit_card) do
    {:ok, Map.delete(params, "credit_card")}
  end

  defp handle_valid_card(_params), do: {:error, "Card is not valid"}

  def handle_availability({:ok, hosting}, firm),
    do: Availability.call(hosting, String.to_atom(firm))

  def handle_availability({:error, _reason} = error, _firm), do: error
end
