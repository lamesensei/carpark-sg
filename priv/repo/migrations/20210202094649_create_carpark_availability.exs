defmodule CarparkSg.Repo.Migrations.CreateCarparkAvailability do
  use Ecto.Migration

  def change do
    create table(:carpark_availability) do
      add(:carpark_info, {:array, :map})
      add(:update_datetime, :utc_datetime)
      add(:available_lots, :integer)
      add(:total_lots, :integer)

      add(
        :car_park_no,
        references(:carparks, column: :car_park_no, type: :string, on_delete: :delete_all)
      )

      timestamps()
    end

    # create(index(:carpark_availability, [:car_park_no]))
    create(unique_index(:carpark_availability, [:car_park_no]))
  end
end
