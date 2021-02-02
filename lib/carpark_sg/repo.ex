defmodule CarparkSg.Repo do
  use Ecto.Repo,
    otp_app: :carpark_sg,
    adapter: Ecto.Adapters.Postgres
end
