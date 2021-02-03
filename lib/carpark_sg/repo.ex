defmodule CarparkSg.Repo do
  use Ecto.Repo,
    otp_app: :carpark_sg,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 5
end
