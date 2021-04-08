defmodule Exticket.Repo do
  use Ecto.Repo,
    otp_app: :exticket,
    adapter: Ecto.Adapters.Postgres
end
