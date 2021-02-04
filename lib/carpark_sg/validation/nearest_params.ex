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
    |> validate_latitude(:latitude)
    |> validate_longitude(:longitude)
    |> validate_page(:page)
    |> validate_page(:per_page)
  end

  defp string_is_float(value) do
    case Float.parse(value) do
      {float, ""} -> {:ok, float}
      {_float, _remainder} -> false
      :error -> false
    end
  end

  defp string_is_integer(value) do
    case Integer.parse(value) do
      {integer, ""} -> {:ok, integer}
      {_integer, _remainder} -> false
      :error -> false
    end
  end

  defp validate_latitude(changeset, field) do
    validate_change(changeset, field, fn field, value ->
      with {:ok, float} <- string_is_float(value),
           true <- float <= 90 and float >= -90 do
        []
      else
        _ -> [{field, "Latitude should be between 90 and -90"}]
      end
    end)
  end

  defp validate_longitude(changeset, field) do
    validate_change(changeset, field, fn field, value ->
      with {:ok, float} <- string_is_float(value),
           true <- float <= 180 and float >= -180 do
        []
      else
        _ -> [{field, "Longitude should be between 180 and -180"}]
      end
    end)
  end

  defp validate_page(changeset, field) do
    validate_change(changeset, field, fn field, value ->
      with {:ok, integer} <- string_is_integer(value),
           true <- integer > 0 do
        []
      else
        _ -> [{field, "Pagination value should be above 0"}]
      end
    end)
  end
end
