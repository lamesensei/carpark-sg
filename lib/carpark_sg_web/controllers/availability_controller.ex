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

  def show(conn, %{"id" => id, "nearest" => "true"}) do
    availability = Carparks.get_availability!(id)
    render(conn, "nearest.json", availability: availability)
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

  def list_nearest(conn, params) do
    with %Scrivener.Page{
           entries: entries,
           page_number: page_number,
           page_size: page_size,
           total_entries: total_entries,
           total_pages: total_pages
         } <- Carparks.list_carpark_availability_nearest(params) do
      render(conn, "paged.json",
        entries: entries,
        page_number: page_number,
        page_size: page_size,
        total_pages: total_pages,
        total_entries: total_entries
      )
    end
  end
end
