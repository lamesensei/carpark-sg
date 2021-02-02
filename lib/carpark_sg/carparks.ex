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
    Repo.all(Information)
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
  def get_information!(id), do: Repo.get!(Information, id)

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
end
