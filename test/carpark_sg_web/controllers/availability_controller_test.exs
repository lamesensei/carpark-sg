defmodule CarparkSgWeb.AvailabilityControllerTest do
  use CarparkSgWeb.ConnCase

  alias CarparkSg.Carparks
  alias CarparkSg.Carparks.Availability

  @create_attrs %{
    carpark_info: [],
    update_datetime: "2010-04-17T14:00:00Z",
    available_lots: 69,
    total_lots: 420,
    car_park_no: "some car_park_no"
  }
  @update_attrs %{
    carpark_info: [%{"BRUH" => "BRUUH"}],
    update_datetime: "2011-05-18T15:01:01Z",
    available_lots: 68,
    total_lots: 421,
    car_park_no: "some updated car_park_no"
  }
  @invalid_attrs %{carpark_info: nil, update_datetime: nil}
  @create_information_attrs %{
    address: "some address",
    car_park_basement: "some car_park_basement",
    car_park_decks: 42,
    car_park_no: "some car_park_no",
    car_park_type: "some car_park_type",
    free_parking: "some free_parking",
    gantry_height: 120.5,
    lat: 120.5,
    lon: 120.5,
    night_parking: "some night_parking",
    short_term_parking: "some short_term_parking",
    type_of_parking_system: "some type_of_parking_system",
    x_coord: 120.5,
    y_coord: 120.5,
    geom: %Geo.Point{
      coordinates: {103.8189, 1.2653},
      srid: 4326
    }
  }
  @update_information_attrs %{
    address: "some updated address",
    car_park_basement: "some updated car_park_basement",
    car_park_decks: 43,
    car_park_no: "some updated car_park_no",
    car_park_type: "some updated car_park_type",
    free_parking: "some updated free_parking",
    gantry_height: 456.7,
    lat: 456.7,
    lon: 456.7,
    night_parking: "some updated night_parking",
    short_term_parking: "some updated short_term_parking",
    type_of_parking_system: "some updated type_of_parking_system",
    x_coord: 456.7,
    y_coord: 456.7,
    geom: %Geo.Point{
      coordinates: {102.8189, 1.3653},
      srid: 4326
    }
  }

  def fixture(:availability) do
    {:ok, _information} = Carparks.create_information(@create_information_attrs)
    {:ok, _updated_information} = Carparks.create_information(@update_information_attrs)
    {:ok, availability} = Carparks.create_availability(@create_attrs)
    availability
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all carpark_availability", %{conn: conn} do
      conn = get(conn, Routes.availability_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create availability" do
    test "renders availability when data is valid", %{conn: conn} do
      Carparks.create_information(@create_information_attrs)
      conn = post(conn, Routes.availability_path(conn, :create), availability: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.availability_path(conn, :show, id))

      assert %{
               "id" => id,
               "carpark_info" => [],
               "update_datetime" => "2010-04-17T14:00:00Z",
               "available_lots" => 69,
               "total_lots" => 420,
               "car_park_no" => "some car_park_no"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.availability_path(conn, :create), availability: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update availability" do
    setup [:create_availability]

    test "renders availability when data is valid", %{
      conn: conn,
      availability: %Availability{id: id} = availability
    } do
      conn =
        put(conn, Routes.availability_path(conn, :update, availability),
          availability: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.availability_path(conn, :show, id))

      assert %{
               "id" => id,
               "carpark_info" => [%{"BRUH" => "BRUUH"}],
               "update_datetime" => "2011-05-18T15:01:01Z",
               "available_lots" => 68,
               "total_lots" => 421,
               "car_park_no" => "some updated car_park_no"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, availability: availability} do
      conn =
        put(conn, Routes.availability_path(conn, :update, availability),
          availability: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete availability" do
    setup [:create_availability]

    test "deletes chosen availability", %{conn: conn, availability: availability} do
      conn = delete(conn, Routes.availability_path(conn, :delete, availability))
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, Routes.availability_path(conn, :show, availability))
      end)
    end
  end

  describe "show availability" do
    setup [:create_availability]

    test "show availability with nearest param", %{conn: conn, availability: availability} do
      conn = get(conn, Routes.availability_path(conn, :show, availability, nearest: "true"))

      assert json_response(conn, 200) == %{
               "address" => "some address",
               "available_lots" => 69,
               "car_park_no" => "some car_park_no",
               "latitude" => 120.5,
               "longitude" => 120.5,
               "total_lots" => 420
             }
    end
  end

  describe "nearest" do
    test "list nearest availability", %{conn: conn} do
      Carparks.create_information(@create_information_attrs)
      conn = post(conn, Routes.availability_path(conn, :create), availability: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.availability_path(conn, :show, id, nearest: "true"))
      availability = json_response(conn, 200)

      conn =
        get(
          conn,
          Routes.availability_path(conn, :list_nearest,
            latitude: "1.2653",
            longitude: "103.8189",
            page: "1",
            per_page: "1"
          )
        )

      assert json_response(conn, 200) ==
               %{
                 "data" => [
                   availability
                 ],
                 "page_number" => 1,
                 "page_size" => 1,
                 "total_entries" => 1,
                 "total_pages" => 1
               }
    end
  end

  defp create_availability(_) do
    availability = fixture(:availability)
    %{availability: availability}
  end
end
