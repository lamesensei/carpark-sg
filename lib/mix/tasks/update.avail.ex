defmodule Mix.Tasks.Update.Avail do
  use Mix.Task

  alias CarparkSg.Carparks.Availability
  alias CarparkSg.Repo

  import Ecto

  @api_url "https://api.data.gov.sg/v1/transport/carpark-availability"
  @shortdoc "Retrieves carpark availability data and store in database"

  @moduledoc """
  This is where we would put any long form documentation or doctests.
  """

  def run(_args) do
    Mix.Task.run("app.start")
    delete_all()
    get_availability()
  end

  defp delete_all() do
    Repo.delete_all(Availability)
  end

  defp get_availability() do
    url = @api_url

    HTTPoison.start()

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        json = Jason.decode!(body)

        json["items"]
        |> List.first()
        |> Map.get("carpark_data", [])
        |> Enum.each(fn data ->
          changeset =
            Availability.changeset(%Availability{}, %{
              car_park_no: data["carpark_number"],
              carpark_info: data["carpark_info"],
              update_datetime: data["update_datetime"]
            })

          Repo.insert(changeset)
        end)

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts("Not found :(")

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end

  # We can define other functions as needed here.
end
