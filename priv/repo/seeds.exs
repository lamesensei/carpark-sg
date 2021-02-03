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

  def insert(row) do
    row
    |> convert_svy21()
    |> changeset()
    |> Repo.insert_or_update!()
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
|> Enum.take(5)
|> Enum.each(&CarparkSeeder.insert/1)
