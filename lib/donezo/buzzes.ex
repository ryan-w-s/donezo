defmodule Donezo.Buzzes do
  @moduledoc """
  The Buzzes context.
  """

  import Ecto.Query, warn: false
  alias Donezo.Repo

  alias Donezo.Buzzes.Buzz

  @doc """
  Returns the list of buzzes.

  ## Examples

      iex> list_buzzes()
      [%Buzz{}, ...]

  """
  def list_buzzes do
    Repo.all(Buzz)
  end

  @doc """
  Gets a single buzz.

  Raises `Ecto.NoResultsError` if the Buzz does not exist.

  ## Examples

      iex> get_buzz!(123)
      %Buzz{}

      iex> get_buzz!(456)
      ** (Ecto.NoResultsError)

  """
  def get_buzz!(id), do: Repo.get!(Buzz, id)

  @doc """
  Creates a buzz.

  ## Examples

      iex> create_buzz(%{field: value})
      {:ok, %Buzz{}}

      iex> create_buzz(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_buzz(attrs \\ %{}) do
    %Buzz{}
    |> Buzz.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a buzz.

  ## Examples

      iex> update_buzz(buzz, %{field: new_value})
      {:ok, %Buzz{}}

      iex> update_buzz(buzz, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_buzz(%Buzz{} = buzz, attrs) do
    buzz
    |> Buzz.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a buzz.

  ## Examples

      iex> delete_buzz(buzz)
      {:ok, %Buzz{}}

      iex> delete_buzz(buzz)
      {:error, %Ecto.Changeset{}}

  """
  def delete_buzz(%Buzz{} = buzz) do
    Repo.delete(buzz)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking buzz changes.

  ## Examples

      iex> change_buzz(buzz)
      %Ecto.Changeset{data: %Buzz{}}

  """
  def change_buzz(%Buzz{} = buzz, attrs \\ %{}) do
    Buzz.changeset(buzz, attrs)
  end
end
