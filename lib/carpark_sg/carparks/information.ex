defmodule CarparkSg.Carparks.Information do
  use Ecto.Schema
  import Ecto.Changeset

  alias CarparkSg.Carparks.Availability

  schema "carparks" do
    field(:address, :string)
    field(:car_park_basement, :string)
    field(:car_park_decks, :integer)
    field(:car_park_no, :string)
    field(:car_park_type, :string)
    field(:free_parking, :string)
    field(:gantry_height, :float)
    field(:lat, :float)
    field(:lon, :float)
    field(:night_parking, :string)
    field(:short_term_parking, :string)
    field(:type_of_parking_system, :string)
    field(:x_coord, :float)
    field(:y_coord, :float)

    has_one(:availability, Availability, foreign_key: :car_park_no, references: :car_park_no)

    timestamps()
  end

  @doc false
  def changeset(information, attrs) do
    information
    |> cast(attrs, [
      :car_park_no,
      :address,
      :x_coord,
      :y_coord,
      :car_park_type,
      :type_of_parking_system,
      :short_term_parking,
      :free_parking,
      :night_parking,
      :car_park_decks,
      :gantry_height,
      :car_park_basement,
      :lat,
      :lon
    ])
    |> unique_constraint(:car_park_no)

    # |> validate_required([:car_park_no, :address, :x_coord, :y_coord, :car_park_type, :type_of_parking_system, :short_term_parking, :free_parking, :night_parking, :car_park_decks, :gantry_height, :car_park_basement, :lat, :lon])
  end
end
