defmodule Mix.Tasks.Update.Avail do
  use Mix.Task

  alias CarparkSg.Carparks.Availability
  alias CarparkSg.Carparks.Information
  alias CarparkSg.Repo

  @api_url "https://api.data.gov.sg/v1/transport/carpark-availability"
  @shortdoc "Retrieves carpark availability data and store in database"

  @moduledoc """
  This is where we would put any long form documentation or doctests.
  """

  def run(_args) do
    Mix.Task.run("app.start")
    # delete_all()
    get_availability()
  end

  # defp delete_all() do
  #   Repo.delete_all(Availability)
  # end

  defp get_availability() do
    {:ok, sg_now} = DateTime.now("Asia/Singapore")
    sg_now = DateTime.to_iso8601(sg_now) |> String.slice(0..18)
    url = @api_url <> "?date_time=#{sg_now}"
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    carpark_nos = Information |> Repo.all() |> Enum.map(& &1.car_park_no)

    HTTPoison.start()

    IO.puts("Retrieving availability from API")

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        json = Jason.decode!(body)

        new_data =
          json["items"]
          |> List.first()
          |> Map.get("carpark_data", [])
          # |> Enum.take(5)
          |> Enum.reduce([], fn data, acc ->
            merged =
              combine_lots(data["carpark_info"])
              |> Map.merge(%{
                "car_park_no" => data["carpark_number"],
                "carpark_info" => data["carpark_info"],
                "update_datetime" => data["update_datetime"],
                "updated_at" => now,
                "inserted_at" => now
              })

            changeset = Availability.changeset(%Availability{}, merged)

            case changeset.valid? do
              true -> [changeset.changes | acc]
              _ -> acc
            end
          end)
          |> Enum.filter(fn change ->
            Enum.member?(carpark_nos, change.car_park_no)
          end)
          # |> Enum.sort_by(& &1.update_datetime, {:desc, DateTime})
          |> Enum.uniq_by(& &1.car_park_no)

        IO.puts("#{length(new_data)} update rows retrieved and processed. Preparing to insert")

        case Repo.insert_all(Availability, new_data,
               on_conflict: :replace_all,
               conflict_target: [:car_park_no]
             ) do
          {rows, nil} -> IO.puts("#{rows} inserted!")
          _ -> IO.puts("Something went wrong")
        end

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
end
