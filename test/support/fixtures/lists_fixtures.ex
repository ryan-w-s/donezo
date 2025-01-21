defmodule Donezo.ListsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Donezo.Lists` context.
  """

  @doc """
  Generate a list.
  """
  def list_fixture(attrs \\ %{}) do
    {:ok, list} =
      attrs
      |> Enum.into(%{
        title: "some title"
      })
      |> Donezo.Lists.create_list()

    list
  end
end
