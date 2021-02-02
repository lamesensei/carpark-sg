defmodule CarparkSg.Carparks do
  @moduledoc """
  The Carparks context.
  """

  import Ecto.Query, warn: false
  alias CarparkSg.Repo

  alias CarparkSg.Carparks.Information

  @doc """
  Returns the list of carparks.

  ## Examples

      iex> list_carparks()
      [%Information{}, ...]

  """
  def list_carparks do
    Information
    |> limit(2)
    |> Repo.all()
    |> Repo.preload(:availability)
  end

  @doc """
  Gets a single information.

  Raises `Ecto.NoResultsError` if the Information does not exist.

  ## Examples

      iex> get_information!(123)
      %Information{}

      iex> get_information!(456)
      ** (Ecto.NoResultsError)

  """
  def get_information!(id) do
    Repo.get!(Information, id) |> Repo.preload(:availability)
  end

  @doc """
  Creates a information.

  ## Examples

      iex> create_information(%{field: value})
      {:ok, %Information{}}

      iex> create_information(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_information(attrs \\ %{}) do
    %Information{}
    |> Information.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a information.

  ## Examples

      iex> update_information(information, %{field: new_value})
      {:ok, %Information{}}

      iex> update_information(information, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_information(%Information{} = information, attrs) do
    information
    |> Information.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a information.

  ## Examples

      iex> delete_information(information)
      {:ok, %Information{}}

      iex> delete_information(information)
      {:error, %Ecto.Changeset{}}

  """
  def delete_information(%Information{} = information) do
    Repo.delete(information)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking information changes.

  ## Examples

      iex> change_information(information)
      %Ecto.Changeset{data: %Information{}}

  """
  def change_information(%Information{} = information, attrs \\ %{}) do
    Information.changeset(information, attrs)
  end

  alias CarparkSg.Carparks.Availability

  @doc """
  Returns the list of carpark_availability.

  ## Examples

      iex> list_carpark_availability()
      [%Availability{}, ...]

  """
  def list_carpark_availability do
    Repo.all(Availability)
  end

  @doc """
  Gets a single availability.

  Raises `Ecto.NoResultsError` if the Availability does not exist.

  ## Examples

      iex> get_availability!(123)
      %Availability{}

      iex> get_availability!(456)
      ** (Ecto.NoResultsError)

  """
  def get_availability!(id), do: Repo.get!(Availability, id)

  @doc """
  Creates a availability.

  ## Examples

      iex> create_availability(%{field: value})
      {:ok, %Availability{}}

      iex> create_availability(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_availability(attrs \\ %{}) do
    %Availability{}
    |> Availability.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a availability.

  ## Examples

      iex> update_availability(availability, %{field: new_value})
      {:ok, %Availability{}}

      iex> update_availability(availability, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_availability(%Availability{} = availability, attrs) do
    availability
    |> Availability.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a availability.

  ## Examples

      iex> delete_availability(availability)
      {:ok, %Availability{}}

      iex> delete_availability(availability)
      {:error, %Ecto.Changeset{}}

  """
  def delete_availability(%Availability{} = availability) do
    Repo.delete(availability)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking availability changes.

  ## Examples

      iex> change_availability(availability)
      %Ecto.Changeset{data: %Availability{}}

  """
  def change_availability(%Availability{} = availability, attrs \\ %{}) do
    Availability.changeset(availability, attrs)
  end
end