defmodule Donezo.Buzzes.Buzz do
  use Ecto.Schema
  import Ecto.Changeset

  schema "buzzes" do
    field :title, :string
    field :completed, :boolean, default: false
    field :completed_at, :utc_datetime
    belongs_to :list, Donezo.Lists.List
    belongs_to :user, Donezo.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(buzz, attrs) do
    buzz
    |> cast(attrs, [:title, :completed, :completed_at, :list_id, :user_id])
    |> validate_required([:title, :list_id, :user_id])
    |> foreign_key_constraint(:list_id)
    |> foreign_key_constraint(:user_id)
  end
end
