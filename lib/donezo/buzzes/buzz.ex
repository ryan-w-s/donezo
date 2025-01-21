defmodule Donezo.Buzzes.Buzz do
  use Ecto.Schema
  import Ecto.Changeset

  schema "buzzes" do
    field :title, :string
    field :completed, :boolean, default: false
    field :completed_at, :utc_datetime
    field :list_id, :id
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(buzz, attrs) do
    buzz
    |> cast(attrs, [:title, :completed, :completed_at])
    |> validate_required([:title, :completed, :completed_at])
  end
end
