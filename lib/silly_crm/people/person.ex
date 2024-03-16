defmodule SillyCrm.People.Person do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, except: [:__meta__]}

  schema "people" do
    field :birth_date, :date
    field :first_name, :string
    field :last_name, :string

    timestamps()
  end

  @doc false
  def changeset(person, attrs) do
    person
    |> cast(attrs, [:first_name, :last_name, :birth_date])
    |> validate_required([:first_name, :last_name, :birth_date])
  end
end
