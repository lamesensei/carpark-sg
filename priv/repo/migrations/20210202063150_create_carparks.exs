defmodule CarparkSg.Repo.Migrations.CreateCarparks do
  use Ecto.Migration

  def change do
    create table(:carparks) do
      add :car_park_no, :string
      add :address, :string
      add :x_coord, :float
      add :y_coord, :float
      add :car_park_type, :string
      add :type_of_parking_system, :string
      add :short_term_parking, :string
      add :free_parking, :string
      add :night_parking, :string
      add :car_park_decks, :integer
      add :gantry_height, :float
      add :car_park_basement, :string
      add :lat, :float
      add :lon, :float

      timestamps()
    end

  end
end
