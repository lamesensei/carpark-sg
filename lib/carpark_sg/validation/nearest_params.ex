defmodule CarparkSg.Validation.NearestParams do
  use Ecto.Schema
  import Ecto.Changeset
  alias CarparkSg.Validation.NearestParams

  embedded_schema do
    field(:latitude, :string)
    field(:longitude, :string)
    field(:page, :string)
    field(:per_page, :string)
  end

  @doc false
  def changeset(%NearestParams{} = nearest_params, attrs) do
    nearest_params
    |> cast(attrs, [:latitude, :longitude, :per_page, :page])
    |> validate_required([:latitude, :longitude, :per_page, :page])
    |> validate_string_is_float(:latitude)
    |> validate_string_is_float(:longitude)
    |> validate_string_is_integer(:per_page)
    |> validate_string_is_integer(:page)
    |> validate_latitude(:latitude)
    |> validate_longitude(:longitude)
    |> validate_page(:page)
    |> validate_page(:per_page)
  end

  defp validate_string_is_float(changeset, field) do
    validate_change(changeset, field, fn field, value ->
      try do
        String.to_float(value)
        []
      rescue
        e in ArgumentError ->
          [{field, "Please provide a valid float"}]
      end
    end)
  end

  defp validate_string_is_integer(changeset, field) do
    validate_change(changeset, field, fn field, value ->
      try do
        String.to_integer(value)
        []
      rescue
        e in ArgumentError ->
          [{field, "Please provide a valid integer"}]
      end
    end)
  end

  defp validate_latitude(changeset, field) do
    validate_change(changeset, field, fn field, value ->
      lat = String.to_float(value)

      if lat <= 90 and lat >= -90 do
        []
      else
        [{field, "Latitude should be between 90 and -90"}]
      end
    end)
  end

  defp validate_longitude(changeset, field) do
    validate_change(changeset, field, fn field, value ->
      lon = String.to_float(value)

      if lon <= 180 and lon >= -180 do
        []
      else
        [{field, "Longitude should be between 180 and -180"}]
      end
    end)
  end

  defp validate_page(changeset, field) do
    validate_change(changeset, field, fn field, value ->
      page = String.to_integer(value)

      if page > 0 do
        []
      else
        [{field, "Pagination value should be above 0"}]
      end
    end)
  end
end
