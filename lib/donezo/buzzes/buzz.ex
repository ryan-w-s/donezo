defmodule Donezo.Buzzes.Buzz do
  use Ecto.Schema
  import Ecto.Changeset

  schema "buzzes" do
    field :title, :string
    field :completed, :boolean, default: false
    field :completed_at, :utc_datetime
    belongs_to :list, Donezo.Lists.List
    belongs_to :user, Donezo.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(buzz, attrs) do
    buzz
    |> cast(attrs, [:title, :completed, :list_id, :user_id])
    |> validate_required([:title, :list_id, :user_id])
    |> maybe_set_completed_at()
  end

  defp maybe_set_completed_at(changeset) do
    case get_change(changeset, :completed) do
      true -> put_change(changeset, :completed_at, DateTime.utc_now() |> DateTime.truncate(:second))
      false -> put_change(changeset, :completed_at, nil)
      nil -> changeset
    end
  end
end
