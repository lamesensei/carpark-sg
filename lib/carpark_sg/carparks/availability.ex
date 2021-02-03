defmodule CarparkSg.Carparks.Availability do
  use Ecto.Schema
  import Ecto.Changeset

  alias CarparkSg.Carparks.Information

  schema "carpark_availability" do
    field :carpark_info, {:array, :map}
    field :update_datetime, :utc_datetime
    field :available_lots, :integer
    field :total_lots, :integer

    belongs_to :information, Information,
      foreign_key: :car_park_no,
      type: :string,
      primary_key: false,
      define_field: :car_park_no,
      references: :car_park_no

    timestamps()
  end

  @doc false
  def changeset(availability, attrs) do
    availability
    |> cast(attrs, [:carpark_info, :update_datetime, :car_park_no, :available_lots, :total_lots])
    |> validate_required([:carpark_info, :update_datetime, :car_park_no])
    |> foreign_key_constraint(:car_park_no)
  end
end
