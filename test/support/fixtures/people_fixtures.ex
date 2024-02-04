defmodule SillyCrm.PeopleFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SillyCrm.People` context.
  """

  @doc """
  Generate a person.
  """
  def person_fixture(attrs \\ %{}) do
    {:ok, person} =
      attrs
      |> Enum.into(%{
        birth_date: ~D[2024-02-03],
        first_name: "some first_name",
        last_name: "some last_name"
      })
      |> SillyCrm.People.create_person()

    person
  end
end
