defmodule CarparkSgWeb.InformationControllerTest do
  use CarparkSgWeb.ConnCase

  alias CarparkSg.Carparks
  alias CarparkSg.Carparks.Information

  @create_attrs %{
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
    y_coord: 120.5
  }
  @update_attrs %{
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
    y_coord: 456.7
  }
  @invalid_attrs %{address: nil, car_park_basement: nil, car_park_decks: nil, car_park_no: nil, car_park_type: nil, free_parking: nil, gantry_height: nil, lat: nil, lon: nil, night_parking: nil, short_term_parking: nil, type_of_parking_system: nil, x_coord: nil, y_coord: nil}

  def fixture(:information) do
    {:ok, information} = Carparks.create_information(@create_attrs)
    information
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all carparks", %{conn: conn} do
      conn = get(conn, Routes.information_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create information" do
    test "renders information when data is valid", %{conn: conn} do
      conn = post(conn, Routes.information_path(conn, :create), information: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.information_path(conn, :show, id))

      assert %{
               "id" => id,
               "address" => "some address",
               "car_park_basement" => "some car_park_basement",
               "car_park_decks" => 42,
               "car_park_no" => "some car_park_no",
               "car_park_type" => "some car_park_type",
               "free_parking" => "some free_parking",
               "gantry_height" => 120.5,
               "lat" => 120.5,
               "lon" => 120.5,
               "night_parking" => "some night_parking",
               "short_term_parking" => "some short_term_parking",
               "type_of_parking_system" => "some type_of_parking_system",
               "x_coord" => 120.5,
               "y_coord" => 120.5
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.information_path(conn, :create), information: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update information" do
    setup [:create_information]

    test "renders information when data is valid", %{conn: conn, information: %Information{id: id} = information} do
      conn = put(conn, Routes.information_path(conn, :update, information), information: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.information_path(conn, :show, id))

      assert %{
               "id" => id,
               "address" => "some updated address",
               "car_park_basement" => "some updated car_park_basement",
               "car_park_decks" => 43,
               "car_park_no" => "some updated car_park_no",
               "car_park_type" => "some updated car_park_type",
               "free_parking" => "some updated free_parking",
               "gantry_height" => 456.7,
               "lat" => 456.7,
               "lon" => 456.7,
               "night_parking" => "some updated night_parking",
               "short_term_parking" => "some updated short_term_parking",
               "type_of_parking_system" => "some updated type_of_parking_system",
               "x_coord" => 456.7,
               "y_coord" => 456.7
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, information: information} do
      conn = put(conn, Routes.information_path(conn, :update, information), information: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete information" do
    setup [:create_information]

    test "deletes chosen information", %{conn: conn, information: information} do
      conn = delete(conn, Routes.information_path(conn, :delete, information))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.information_path(conn, :show, information))
      end
    end
  end

  defp create_information(_) do
    information = fixture(:information)
    %{information: information}
  end
end
