defmodule SillyCrmWeb.PeopleChannel do
  @moduledoc false

  use LiveState.Channel, web_module: SillyCrmWeb

  alias SillyCrm.People

  @impl true
  def init(_channel, _params, _socket) do
    {:ok, %{people: People.list_people(), errors: %{}, editing: false, person: %People.Person{}}}
  end

  @impl true
  def handle_event("add-person", _attrs, state) do
    {:noreply,
     state
     |> Map.put(:editing, true)
     |> Map.put(:person, %People.Person{})
     |> Map.put(:errors, %{})}
  end

  @impl true
  def handle_event("edit-person", %{"id" => person_id}, state) do
    {:noreply,
     state
     |> Map.put(:editing, true)
     |> Map.put(:person, People.get_person!(person_id))
     |> Map.put(:errors, %{})}
  end

  def handle_event("save-person", attrs, %{person: %{id: person_id} = person} = state)
      when not is_nil(person_id) do

    with person <- People.get_person!(person_id),
         {:ok, saved_person} <- People.update_person(person, attrs) do
      {:noreply,
       %{
         people: People.list_people(),
         person: saved_person,
         editing: false
       }}
    else
      {:error, changeset} ->
        {:noreply,
         Map.put(state, :errors, format_errors(changeset))
         |> Map.put(:person, Map.merge(person, attrs) |> IO.inspect(label: "updated person"))}
    end
  end

  def handle_event("save-person", person, state) do
    case People.create_person(person) do
      {:ok, saved_person} ->
        {:noreply,
         %{
           people: People.list_people(),
           person: saved_person,
           editing: false
         }}

      {:error, changeset} ->
        {:noreply, state |> Map.put(:errors, format_errors(changeset)) |> Map.put(:person, person)}
    end
  end

  defp format_errors(%Ecto.Changeset{errors: errors}),
    do: errors |> Enum.map(fn {field, {message, _}} -> {field, message} end) |> Enum.into(%{})
end
