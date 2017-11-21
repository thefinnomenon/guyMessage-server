defmodule Chat.Chats.Chat do
  @moduledoc """
  The Auth context.
  """
  import Plug.Conn
  import Ecto.Query, warn: false
  alias Chat.Repo
  alias Phoenix.Token

  alias Chat.Accounts.User
  alias Chat.Chats.{Conversation, Participant, Message}

  require Logger

  @doc """
  Retrieves all conversations
  ()
  """
  def get_all_conversation() do
    Repo.all(Conversation)
  end

  @doc """
  Retrieves a user's conversation list
  (user_id)
  """
  def get_conversation_list(user_id) do
    # Retrieve list of conversation_id's that the user is part of
    query = from participant in Participant,
            where: participant.user_id == ^user_id,
            select: participant.conversation_id
    conversations = Repo.all(query)

    # Retrieve conversations (including participants and messages)
    query = from conversation in Conversation,
            where: conversation.id in ^conversations, 
            join: participants in assoc(conversation, :participants),
            join: messages in assoc(conversation, :messages),
            join: user in assoc(participants, :user),
            preload: [participants: {participants, user: user}, messages: {messages, user: user}]

    conversations = Repo.all(query)
  end

  @doc """
  Retrieves a conversation by id 
  (conversation_id)
  """
  def get_conversation_by_id(conversation_id) do
    case Repo.get(Conversation, conversation_id) do
      nil           -> {:error, "Conversation not found"}
      conversation  -> {:ok, conversation}
    end
  end

  @doc """
  Retrieves a conversation by participants or creates one if does not exist 
  (user_id, [id1, id2, id3, ...])
  """
  def get_conversation_by_participants(user, participants) do
    query = from conversation in Conversation, 
            preload: [:participants],
            join: participant in assoc(conversation, :participants),
            where: participant.id in ^participants

    case Repo.all(query) do
      []            -> {:ok, create_conversation(user, participants)}
      conversations -> {:ok, conversations}
    end
  end

  @doc """
  Creates a new conversation
  (user_id, [id1, id2, id3, ...])
  """
  def create_conversation(user, participants) do
    participants = Enum.map(participants, fn(participant) -> %{user_id: participant} end)

    Conversation.changeset(%Conversation{}, %{creator_id: user, participants: participants})
    |> Repo.insert
  end

  @doc """
  Adds a participant to a conversation
  (user_id, conversation_id])
  """
  def add_participant(user, conversation) do
    case Repo.get(Conversation, conversation) do
      nil           -> {:error, "Conversation not found"}
      conversation  -> 
        Ecto.build_assoc(conversation, :participants, %{user_id: user})
        |> Repo.insert
    end
  end

  @doc """
  Creates a new message 
  (user_id, conversation_id, "hey"])
  """
  def create_message(user, conversation, message) do
    Message.changeset(%Message{}, %{user_id: user, conversation_id: conversation, message: message})
    |> Repo.insert
  end
end
