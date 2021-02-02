defmodule CarparkSg.CarparksTest do
  use CarparkSg.DataCase

  alias CarparkSg.Carparks

  describe "carparks" do
    alias CarparkSg.Carparks.Information

    @valid_attrs %{address: "some address", car_park_basement: "some car_park_basement", car_park_decks: 42, car_park_no: "some car_park_no", car_park_type: "some car_park_type", free_parking: "some free_parking", gantry_height: 120.5, lat: 120.5, lon: 120.5, night_parking: "some night_parking", short_term_parking: "some short_term_parking", type_of_parking_system: "some type_of_parking_system", x_coord: 120.5, y_coord: 120.5}
    @update_attrs %{address: "some updated address", car_park_basement: "some updated car_park_basement", car_park_decks: 43, car_park_no: "some updated car_park_no", car_park_type: "some updated car_park_type", free_parking: "some updated free_parking", gantry_height: 456.7, lat: 456.7, lon: 456.7, night_parking: "some updated night_parking", short_term_parking: "some updated short_term_parking", type_of_parking_system: "some updated type_of_parking_system", x_coord: 456.7, y_coord: 456.7}
    @invalid_attrs %{address: nil, car_park_basement: nil, car_park_decks: nil, car_park_no: nil, car_park_type: nil, free_parking: nil, gantry_height: nil, lat: nil, lon: nil, night_parking: nil, short_term_parking: nil, type_of_parking_system: nil, x_coord: nil, y_coord: nil}

    def information_fixture(attrs \\ %{}) do
      {:ok, information} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Carparks.create_information()

      information
    end

    test "list_carparks/0 returns all carparks" do
      information = information_fixture()
      assert Carparks.list_carparks() == [information]
    end

    test "get_information!/1 returns the information with given id" do
      information = information_fixture()
      assert Carparks.get_information!(information.id) == information
    end

    test "create_information/1 with valid data creates a information" do
      assert {:ok, %Information{} = information} = Carparks.create_information(@valid_attrs)
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
    end

    test "create_information/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Carparks.create_information(@invalid_attrs)
    end

    test "update_information/2 with valid data updates the information" do
      information = information_fixture()
      assert {:ok, %Information{} = information} = Carparks.update_information(information, @update_attrs)
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
    end

    test "update_information/2 with invalid data returns error changeset" do
      information = information_fixture()
      assert {:error, %Ecto.Changeset{}} = Carparks.update_information(information, @invalid_attrs)
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
end
