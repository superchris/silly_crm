defmodule SillyCrm.Repo do
  use Ecto.Repo,
    otp_app: :silly_crm,
    adapter: Ecto.Adapters.Postgres
end
