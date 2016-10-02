defmodule UserService.Repo.Migrations.CreatePermission do
  use Ecto.Migration

  def change do
    create table(:permissions) do
      add :name, :string
      add :description, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:permissions, [:user_id])

  end
end
