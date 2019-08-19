defmodule Phellow.Repo.Migrations.CreateBoards do
  use Ecto.Migration

  def change do
    create table(:boards) do
      add :title, :string
      add :img_url, :string

      timestamps()
    end

  end
end
