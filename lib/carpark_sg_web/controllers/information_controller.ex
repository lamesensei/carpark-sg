defmodule CarparkSgWeb.InformationController do
  use CarparkSgWeb, :controller

  alias CarparkSg.Carparks
  alias CarparkSg.Carparks.Information

  action_fallback CarparkSgWeb.FallbackController

  def index(conn, _params) do
    carparks = Carparks.list_carparks()
    render(conn, "index.json", carparks: carparks)
  end

  def create(conn, %{"information" => information_params}) do
    with {:ok, %Information{} = information} <- Carparks.create_information(information_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.information_path(conn, :show, information))
      |> render("show.json", information: information)
    end
  end

  def show(conn, %{"id" => id}) do
    information = Carparks.get_information!(id)
    render(conn, "show.json", information: information, availability: information.availability)
  end

  def update(conn, %{"id" => id, "information" => information_params}) do
    information = Carparks.get_information!(id)

    with {:ok, %Information{} = information} <-
           Carparks.update_information(information, information_params) do
      render(conn, "show.json", information: information)
    end
  end

  def delete(conn, %{"id" => id}) do
    information = Carparks.get_information!(id)

    with {:ok, %Information{}} <- Carparks.delete_information(information) do
      send_resp(conn, :no_content, "")
    end
  end

  def nearest(conn, params) do
    # TODO this needs change
    lat = Map.get(params, "latitude", "0.1") |> String.to_float()
    lon = Map.get(params, "longitude", "0.1") |> String.to_float()
    lat_lon = [lat, lon]

    carparks = Carparks.list_carpark_availability_nearest(params)
    IO.inspect(carparks)
    #   |> Enum.map(fn item ->
    #     append_distance(item, lat_lon)
    #   end)
    #   |> Enum.filter(fn item -> item.available_lots > 0 end)
    #   |> Enum.sort_by(& &1.distance)

    render(conn, "index.json", carparks: carparks)
  end
end
