defmodule Chat.Chats.Message do
  use Ecto.Schema
  import Ecto.Changeset

  alias Chat.Chats.Message

  @derive {Poison.Encoder, only: [:user, :message]}
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "messages" do
    belongs_to :conversation, Chat.Chats.Conversation
    belongs_to :user, Chat.Accounts.User
    field :message, :string

    timestamps()
  end

  @doc false
  def changeset(%Message{} = user, attrs) do
    user
    |> cast(attrs, [:conversation_id, :user_id, :message])
    |> validate_required([])
  end
end
