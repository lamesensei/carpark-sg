defmodule CarparkSgWeb.AvailabilityController do
  use CarparkSgWeb, :controller

  alias CarparkSg.Carparks
  alias CarparkSg.Carparks.Availability

  action_fallback(CarparkSgWeb.FallbackController)

  def index(conn, _params) do
    carpark_availability = Carparks.list_carpark_availability()
    render(conn, "index.json", carpark_availability: carpark_availability)
  end

  def create(conn, %{"availability" => availability_params}) do
    with {:ok, %Availability{} = availability} <-
           Carparks.create_availability(availability_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.availability_path(conn, :show, availability))
      |> render("show.json", availability: availability)
    end
  end

  def show(conn, %{"id" => id}) do
    availability = Carparks.get_availability!(id)
    render(conn, "show.json", availability: availability)
  end

  def update(conn, %{"id" => id, "availability" => availability_params}) do
    availability = Carparks.get_availability!(id)

    with {:ok, %Availability{} = availability} <-
           Carparks.update_availability(availability, availability_params) do
      render(conn, "show.json", availability: availability)
    end
  end

  def delete(conn, %{"id" => id}) do
    availability = Carparks.get_availability!(id)

    with {:ok, %Availability{}} <- Carparks.delete_availability(availability) do
      send_resp(conn, :no_content, "")
    end
  end

  def nearest(conn, params) do
    lat = Map.get(params, "latitude", "0") |> String.to_float()
    lon = Map.get(params, "longitude", "0") |> String.to_float()
    lat_lon = [lat, lon]

    carpark_availability =
      Carparks.list_carpark_availability()
      |> Enum.map(fn item ->
        append_distance(item, lat_lon)
      end)
      |> Enum.filter(fn item -> item.available_lots > 0 end)
      |> Enum.sort_by(& &1.distance)

    render(conn, "index.json", carpark_availability: carpark_availability)
  end

  def append_distance(object, lat_lon) do
    distance =
      Geocalc.distance_between(
        [object.information.lat, object.information.lon],
        lat_lon
      )

    Map.merge(object, %{distance: distance})
  end
end
