defmodule CarparkSgWeb.AvailabilityControllerTest do
  use CarparkSgWeb.ConnCase

  alias CarparkSg.Carparks
  alias CarparkSg.Carparks.Availability

  @create_attrs %{
    carpark_info: [],
    update_datetime: "2010-04-17T14:00:00Z"
  }
  @update_attrs %{
    carpark_info: [],
    update_datetime: "2011-05-18T15:01:01Z"
  }
  @invalid_attrs %{carpark_info: nil, update_datetime: nil}

  def fixture(:availability) do
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
      conn = post(conn, Routes.availability_path(conn, :create), availability: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.availability_path(conn, :show, id))

      assert %{
               "id" => id,
               "carpark_info" => [],
               "update_datetime" => "2010-04-17T14:00:00Z"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.availability_path(conn, :create), availability: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update availability" do
    setup [:create_availability]

    test "renders availability when data is valid", %{conn: conn, availability: %Availability{id: id} = availability} do
      conn = put(conn, Routes.availability_path(conn, :update, availability), availability: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.availability_path(conn, :show, id))

      assert %{
               "id" => id,
               "carpark_info" => [],
               "update_datetime" => "2011-05-18T15:01:01Z"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, availability: availability} do
      conn = put(conn, Routes.availability_path(conn, :update, availability), availability: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete availability" do
    setup [:create_availability]

    test "deletes chosen availability", %{conn: conn, availability: availability} do
      conn = delete(conn, Routes.availability_path(conn, :delete, availability))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.availability_path(conn, :show, availability))
      end
    end
  end

  defp create_availability(_) do
    availability = fixture(:availability)
    %{availability: availability}
  end
end
