defmodule Nfd.Meta.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "comments" do
    field :depth, :integer
    field :message, :string
    field :parent_message_id, :string
    field :user_id, :binary_id
    field :page_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:depth, :message, :parent_message_id])
    |> validate_required([:depth, :message, :parent_message_id])
  end
end