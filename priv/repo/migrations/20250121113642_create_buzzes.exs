defmodule Donezo.Repo.Migrations.CreateBuzzes do
  use Ecto.Migration

  def change do
    create table(:buzzes) do
      add :title, :string
      add :completed, :boolean, default: false, null: false
      add :completed_at, :utc_datetime
      add :list_id, references(:lists, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:buzzes, [:list_id])
    create index(:buzzes, [:user_id])
  end
end
