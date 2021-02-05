defmodule CarparkSg.CarparksTest do
  use CarparkSg.DataCase
  alias CarparkSg.Carparks

  describe "carparks" do
    alias CarparkSg.Carparks.Information

    @information_valid_attrs %{
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
        coordinates: {102.8189, 1.2453},
        srid: 4326
      }
    }
    @information_update_attrs %{
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
        coordinates: {103.8189, 1.2653},
        srid: 4326
      }
    }
    @information_invalid_attrs %{
      address: nil,
      car_park_basement: nil,
      car_park_decks: nil,
      car_park_no: nil,
      car_park_type: nil,
      free_parking: nil,
      gantry_height: nil,
      lat: nil,
      lon: nil,
      night_parking: nil,
      short_term_parking: nil,
      type_of_parking_system: nil,
      x_coord: nil,
      y_coord: nil,
      geom: nil
    }

    def information_fixture(attrs \\ %{}, changes \\ @information_valid_attrs) do
      {:ok, information} =
        attrs
        |> Enum.into(changes)
        |> Carparks.create_information()

      information |> Repo.preload(:availability)
    end

    test "list_carparks/0 returns all carparks" do
      information = information_fixture()

      assert Carparks.list_carparks() == [information]
    end

    # test "list_carpark_availability_nearest/1 returns availabilities" do
    #   assert Carparks.list_carpark_availability_nearest(@valid_params) == []
    # end

    test "get_information!/1 returns the information with given id" do
      information =
        information_fixture()
        |> Map.put(:availability, nil)

      assert Carparks.get_information!(information.id) == information
    end

    test "create_information/1 with valid data creates a information" do
      assert {:ok, %Information{} = information} =
               Carparks.create_information(@information_valid_attrs)

      assert information.address == "some address"
      assert information.car_park_basement == "some car_park_basement"
      assert information.car_park_decks == 42
      assert information.car_park_no == "some car_park_no"
      assert information.car_park_type == "some car_park_type"
      assert information.free_parking == "some free_parking"
      assert information.gantry_height == 120.5
      assert information.lat == 120.5
      assert information.lon == 120.5
      assert information.night_parking == "some night_parking"
      assert information.short_term_parking == "some short_term_parking"
      assert information.type_of_parking_system == "some type_of_parking_system"
      assert information.x_coord == 120.5
      assert information.y_coord == 120.5

      assert information.geom == %Geo.Point{
               coordinates: {102.8189, 1.2453},
               srid: 4326
             }
    end

    test "create_information/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Carparks.create_information(@information_invalid_attrs)
    end

    test "update_information/2 with valid data updates the information" do
      information = information_fixture()

      assert {:ok, %Information{} = information} =
               Carparks.update_information(information, @information_update_attrs)

      assert information.address == "some updated address"
      assert information.car_park_basement == "some updated car_park_basement"
      assert information.car_park_decks == 43
      assert information.car_park_no == "some updated car_park_no"
      assert information.car_park_type == "some updated car_park_type"
      assert information.free_parking == "some updated free_parking"
      assert information.gantry_height == 456.7
      assert information.lat == 456.7
      assert information.lon == 456.7
      assert information.night_parking == "some updated night_parking"
      assert information.short_term_parking == "some updated short_term_parking"
      assert information.type_of_parking_system == "some updated type_of_parking_system"
      assert information.x_coord == 456.7
      assert information.y_coord == 456.7

      assert information.geom == %Geo.Point{
               coordinates: {103.8189, 1.2653},
               srid: 4326
             }
    end

    test "update_information/2 with invalid data returns error changeset" do
      information = information_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Carparks.update_information(information, @information_invalid_attrs)

      assert information == Carparks.get_information!(information.id)
    end

    test "delete_information/1 deletes the information" do
      information = information_fixture()
      assert {:ok, %Information{}} = Carparks.delete_information(information)
      assert_raise Ecto.NoResultsError, fn -> Carparks.get_information!(information.id) end
    end

    test "change_information/1 returns a information changeset" do
      information = information_fixture()
      assert %Ecto.Changeset{} = Carparks.change_information(information)
    end
  end

  describe "carpark_availability" do
    alias CarparkSg.Carparks.Availability

    @availability_valid_attrs %{
      carpark_info: [],
      update_datetime: "2010-04-17T14:00:00Z",
      car_park_no: "some car_park_no",
      available_lots: 50,
      total_lots: 100
    }
    @availability_update_attrs %{
      carpark_info: [%{"updated" => true}],
      update_datetime: "2011-05-18T15:01:01Z",
      car_park_no: "some updated car_park_no",
      available_lots: 99,
      total_lots: 100
    }
    @availability_invalid_attrs %{
      carpark_info: nil,
      update_datetime: nil,
      car_park_no: nil,
      available_lots: 0,
      total_lots: 0
    }
    @valid_nearest_params %{
      "latitude" => "1.2453",
      "longitude" => "102.8189",
      "per_page" => "8",
      "page" => "1"
    }
    @invalid_nearest_params %{
      "latitude" => "1.3a",
      "longitude" => "100b",
      "per_page" => nil,
      "page" => "one"
    }

    def availability_fixture(attrs \\ %{}) do
      _information = information_fixture()

      {:ok, availability} =
        attrs
        |> Enum.into(@availability_valid_attrs)
        |> Carparks.create_availability()

      availability |> Repo.preload(:information)
    end

    test "list_carpark_availability/0 returns all carpark_availability" do
      availability = availability_fixture()
      assert Carparks.list_carpark_availability() == [availability]
    end

    test "get_availability!/1 returns the availability with given id" do
      availability = availability_fixture()
      assert Carparks.get_availability!(availability.id) == availability
    end

    test "create_availability/1 with valid data creates a availability" do
      _information = information_fixture()

      assert {:ok, %Availability{} = availability} =
               Carparks.create_availability(@availability_valid_attrs)

      assert availability.carpark_info == []

      assert availability.update_datetime ==
               DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
    end

    test "create_availability/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Carparks.create_availability(@availability_invalid_attrs)
    end

    test "update_availability/2 with valid data updates the availability" do
      _updated_information = information_fixture(%{}, @information_update_attrs)
      availability = availability_fixture()

      assert {:ok, %Availability{} = availability} =
               Carparks.update_availability(availability, @availability_update_attrs)

      assert availability.carpark_info == [%{"updated" => true}]

      assert availability.update_datetime ==
               DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")

      assert availability.car_park_no == "some updated car_park_no"
    end

    test "update_availability/2 with invalid data returns error changeset" do
      availability = availability_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Carparks.update_availability(availability, @availability_invalid_attrs)

      assert availability == Carparks.get_availability!(availability.id)
    end

    test "delete_availability/1 deletes the availability" do
      availability = availability_fixture()
      assert {:ok, %Availability{}} = Carparks.delete_availability(availability)
      assert_raise Ecto.NoResultsError, fn -> Carparks.get_availability!(availability.id) end
    end

    test "change_availability/1 returns a availability changeset" do
      availability = availability_fixture()
      assert %Ecto.Changeset{} = Carparks.change_availability(availability)
    end

    test "list_carpark_availability_nearest/1 with valid params returns scrinever.page" do
      availability = availability_fixture()

      assert Carparks.list_carpark_availability_nearest(@valid_nearest_params) == %Scrivener.Page{
               entries: [availability],
               page_number: 1,
               page_size: 8,
               total_entries: 1,
               total_pages: 1
             }
    end

    test "list_carpark_availability_nearest/1 with invalid params returns error changeset" do
      availability = availability_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Carparks.list_carpark_availability_nearest(@invalid_nearest_params)
    end
  end
end
