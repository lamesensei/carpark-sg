defmodule CarparkSgWeb.AvailabilityController do
  use CarparkSgWeb, :controller

  alias CarparkSg.Carparks
  alias CarparkSg.Carparks.Availability
  alias CarparkSg.Validation.NearestParams

  plug(:ensure_nearest_params)

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

  def nearest(
        conn,
        %{
          "latitude" => latitude,
          "longitude" => longitude,
          "per_page" => per_page,
          "page" => page
        } = params
      ) do
    render_nearest(conn, params)

    # render(conn, "index.json", carpark_availability: carpark_availability)
  end

  defp render_nearest(conn, params) do
    page =
      Map.put_new(params, "page_size", Map.get(params, "per_page", 0))
      |> Carparks.list_carpark_availability_nearest()

    render(conn, "paged.json",
      entries: page.entries,
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries
    )
  end

  defp ensure_nearest_params(conn, _) do
    changeset = NearestParams.changeset(%NearestParams{}, conn.params)

    case changeset do
      %{
        :params => %{
          "latitude" => latitude,
          "longitude" => longitude,
          "per_page" => per_page,
          "page" => page
        },
        :valid? => true
      } ->
        conn

      _ ->
        conn
        |> put_status(400)
        |> put_view(CarparkSgWeb.ChangesetView)
        |> render("error.json", %{changeset: changeset})
    end
  end
end
