defmodule Donezo.BuzzesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Donezo.Buzzes` context.
  """

  @doc """
  Generate a buzz.
  """
  def buzz_fixture(attrs \\ %{}) do
    {:ok, buzz} =
      attrs
      |> Enum.into(%{
        completed: true,
        completed_at: ~U[2025-01-20 11:36:00Z],
        title: "some title"
      })
      |> Donezo.Buzzes.create_buzz()

    buzz
  end
end
