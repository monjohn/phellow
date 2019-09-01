defmodule Phellow.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add :title, :string
      add :description, :text
      add :list_id, references(:lists, on_delete: :delete_all)

      timestamps()
    end

    create index(:cards, [:list_id])
  end
end
