# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     CarparkSg.Repo.insert!(%CarparkSg.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias CarparkSg.Carparks.Information
alias CarparkSg.Repo

defmodule CarparkSeeder do
  # def bulk_insert(data) do
  #   now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

  #   bulk =
  #     Enum.reduce(data, [], fn value, acc ->
  #       merge =
  #         Map.merge(value, %{
  #           "inserted_at" => now,
  #           "updated_at" => now
  #         })

  #       changeset = Information.changeset(%Information{}, merge)
  #       [changeset | acc]
  #     end)

  #   # Enum.take(bulk, 1) |> IO.inspect()

  #   Repo.insert_all(Information, bulk,
  #     on_conflict: :replace_all,
  #     conflict_target: [:id]
  #   )
  # end

  def insert(row) do
    changeset = Information.changeset(%Information{}, row)
    Repo.insert!(changeset)
  end
end

File.stream!(Path.join(:code.priv_dir(:carpark_sg), "repo/hdb-carpark-information.csv"))
|> CSV.decode!(headers: true)
|> Enum.each(&CarparkSeeder.insert/1)
