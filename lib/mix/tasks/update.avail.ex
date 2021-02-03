defmodule Mix.Tasks.Update.Avail do
  use Mix.Task

  alias CarparkSg.Carparks.Availability
  alias CarparkSg.Repo

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
          merged =
            combine_lots(data["carpark_info"])
            |> Map.merge(%{
              "car_park_no" => data["carpark_number"],
              "carpark_info" => data["carpark_info"],
              "update_datetime" => data["update_datetime"]
            })

          Availability.changeset(%Availability{}, merged)
          |> Repo.insert()
        end)

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts("Not found :(")

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end

  defp combine_lots(object) do
    Enum.reduce(object, %{"total_lots" => 0, "available_lots" => 0}, fn info, acc ->
      %{
        acc
        | "total_lots" => String.to_integer(info["total_lots"]) + acc["total_lots"],
          "available_lots" => String.to_integer(info["lots_available"]) + acc["available_lots"]
      }
    end)
  end

  # We can define other functions as needed here.
end
