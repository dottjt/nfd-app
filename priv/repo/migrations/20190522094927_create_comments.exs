defmodule Nfd.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :depth, :integer
      add :name, :string
      add :email, :string
      add :message, :string
      
      add :parent_message_id, references(:comments, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      
      # NOTE: This is not elegant and should be a foreign key
      # add :page_id, references(:pages, on_delete: :nothing, type: :binary_id)
      add :page_id, :binary_id

      timestamps()
    end

    create index(:comments, [:user_id])
    # create index(:comments, [:page_id])
  end
end
