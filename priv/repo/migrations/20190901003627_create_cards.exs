defmodule Phellow.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add :title, :string, null: false
      add :description, :text
      add :list_id, references(:lists, on_delete: :delete_all), null: false
      add :position, :integer, default: 0

      timestamps()
    end

    create index(:cards, [:list_id])
  end
end
