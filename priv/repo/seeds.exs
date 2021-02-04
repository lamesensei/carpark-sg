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
  @convert_url "https://developers.onemap.sg/commonapi/convert/3414to4326?"

  # def insert(row) do
  #   changeset
  #   |> convert_svy21()
  #   |> changeset()
  # end

  def bulk_insert(rows) do
    IO.puts("SEEDING HDB CARPARK INFORMATION FROM CSV")

    bulk_data =
      Enum.reduce(rows, [], fn row, acc ->
        IO.inspect(row)

        changeset =
          row
          |> convert_svy21
          |> append_dates
          |> changeset

        case changeset.valid? do
          true -> [changeset.changes | acc]
          _ -> acc
        end
      end)

    IO.puts("#{length(bulk_data)} rows processed")
    IO.puts("Performing insert_all")

    Repo.insert_all(
      Information,
      bulk_data
      # on_conflict: :replace_all,
      # conflict_target: [:car_park_no]
    )
  end

  defp append_dates(row) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    Map.merge(row, %{
      "updated_at" => now,
      "inserted_at" => now
    })
  end

  defp changeset(data) do
    Information.changeset(%Information{}, data)
  end

  defp convert_svy21(row) do
    x = row["x_coord"]
    y = row["y_coord"]

    url = "#{@convert_url}X=#{x}&Y=#{y}"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        coords = Jason.decode!(body)

        geom = %Geo.Point{
          coordinates: {coords["longitude"], coords["latitude"]},
          srid: 4326
        }

        Map.merge(row, %{
          "lat" => coords["latitude"],
          "lon" => coords["longitude"],
          "geom" => geom
        })

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts("Not found :(")

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end
end

Path.join(:code.priv_dir(:carpark_sg), "repo/hdb-carpark-information.csv")
|> File.stream!()
|> CSV.decode!(headers: true)
|> CarparkSeeder.bulk_insert()
