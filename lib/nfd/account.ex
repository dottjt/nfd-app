defmodule Nfd.Account do
  @moduledoc """
  The Account context.
  """

  import Ecto.Query, warn: false
  alias Nfd.Repo

  alias Nfd.Account.User



  # from(u in User, where: u.username == ^username or u.email == ^username)
  # |> Repo.one



  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user_pow!(nil), do: %{}
  def get_user_pow!(user), do: Repo.get!(User, user.id) |> Repo.preload([:subscriber])

  def get_user_email(email), do: Repo.get_by(User, email: email)
  def get_user_email!(email), do: Repo.get_by!(User, email: email)
  def get_user_id_non_error(id), do: Repo.get_by(User, id)

  def get_user_return_id_and_email!(id), do: from(User) |> select([:id, :email]) |> Repo.get!(id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset_update(attrs)
    |> Repo.update()
  end

  def update_user_email_confirm(%User{} = user, attrs) do
    user
    |> User.changeset_confirm_email(attrs)
    |> Repo.update()
  end
  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  alias Nfd.Account.CollectionAccess

  @doc """
  Returns the list of collection_access.

  ## Examples

      iex> list_collection_access()
      [%CollectionAccess{}, ...]

  """
  def list_collection_access do
    Repo.all(CollectionAccess)
  end

  def list_collection_access_by_user_id(nil), do: []
  def list_collection_access_by_user_id(user_id) do
    Repo.all(
      from c in CollectionAccess,
      where: [ user_id: ^user_id ],
      preload: [:collection]
    )
  end


  @doc """
  Gets a single collection_access.

  Raises `Ecto.NoResultsError` if the Collection access does not exist.

  ## Examples

      iex> get_collection_access!(123)
      %CollectionAccess{}

      iex> get_collection_access!(456)
      ** (Ecto.NoResultsError)

  """
  def get_collection_access!(id), do: Repo.get!(CollectionAccess, id)

  def get_collection_access_by_user_id_and_collection_id(nil, collection_id), do: %{}
  def get_collection_access_by_user_id_and_collection_id(user_id, collection_id) do
    from(u in CollectionAccess, where: u.user_id == ^user_id and u.collection_id == ^collection_id) |> Repo.one
  end




  @doc """
  Creates a collection_access.

  ## Examples

      iex> create_collection_access(%{field: value})
      {:ok, %CollectionAccess{}}

      iex> create_collection_access(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_collection_access(attrs \\ %{}) do
    %CollectionAccess{}
    |> CollectionAccess.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a collection_access.

  ## Examples

      iex> update_collection_access(collection_access, %{field: new_value})
      {:ok, %CollectionAccess{}}

      iex> update_collection_access(collection_access, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_collection_access(%CollectionAccess{} = collection_access, attrs) do
    collection_access
    |> CollectionAccess.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a CollectionAccess.

  ## Examples

      iex> delete_collection_access(collection_access)
      {:ok, %CollectionAccess{}}

      iex> delete_collection_access(collection_access)
      {:error, %Ecto.Changeset{}}

  """
  def delete_collection_access(%CollectionAccess{} = collection_access) do
    Repo.delete(collection_access)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking collection_access changes.

  ## Examples

      iex> change_collection_access(collection_access)
      %Ecto.Changeset{source: %CollectionAccess{}}

  """
  def change_collection_access(%CollectionAccess{} = collection_access) do
    CollectionAccess.changeset(collection_access, %{})
  end

  alias Nfd.Account.Subscriber

  @doc """
  Returns the list of subscribers.

  ## Examples

      iex> list_subscribers()
      [%Subscriber{}, ...]

  """
  def list_subscribers do
    Repo.all(Subscriber)
  end

  def list_subscribers_general do
    Repo.all(
      from s in Subscriber,
      where: [ subscribed: true ]
    )
  end

  def list_subscribers_kickstarter do
    Repo.all(
      from s in Subscriber,
      where: [ seven_day_kickstarter_subscribed: true ]
    )
  end

  def list_subscribers_meditation do
    Repo.all(
      from s in Subscriber,
      where: [ ten_day_meditation_subscribed: true ]
    )
  end

  def list_subscribers_awareness do
    Repo.all(
      from s in Subscriber,
      where: [ awareness_seven_week_vol_1_subscribed: true ],
      or_where: [ awareness_seven_week_vol_2_subscribed: true ],
      or_where: [ awareness_seven_week_vol_3_subscribed: true ],
      or_where: [ awareness_seven_week_vol_4_subscribed: true ]
    )
  end

  def list_subscribers_campaign do
    Repo.all(
      from s in Subscriber,
      where: [ seven_day_kickstarter_subscribed: true ],
      or_where: [ ten_day_meditation_subscribed: true ],
      or_where: [ twenty_eight_day_awareness_subscribed: true ]
    )
  end


  @doc """
  Gets a single subscriber.

  Raises `Ecto.NoResultsError` if the Subscriber does not exist.

  ## Examples

      iex> get_subscriber!(123)
      %Subscriber{}

      iex> get_subscriber!(456)
      ** (Ecto.NoResultsError)

  """
  def get_subscriber!(id), do: Repo.get!(Subscriber, id)
  def get_subscriber_user_id(user_id), do: Repo.get_by(Subscriber, user_id: user_id)
  def get_subscriber_email(subscriber_email), do: Repo.get_by(Subscriber, subscriber_email: subscriber_email)

  @doc """
  Creates a subscriber.

  ## Examples

      iex> create_subscriber(%{field: value})
      {:ok, %Subscriber{}}

      iex> create_subscriber(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_subscriber(attrs \\ %{}) do
    IO.inspect attrs

    %Subscriber{}
    |> Subscriber.changeset(attrs)
    |> Repo.insert()

    # My additional modification
    # get_subscriber_email(attrs.subscriber_email)
  end

  @doc """
  Updates a subscriber.

  ## Examples

      iex> update_subscriber(subscriber, %{field: new_value})
      {:ok, %Subscriber{}}

      iex> update_subscriber(subscriber, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_subscriber(%Subscriber{} = subscriber, attrs) do
    subscriber
    |> Subscriber.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Subscriber.

  ## Examples

      iex> delete_subscriber(subscriber)
      {:ok, %Subscriber{}}

      iex> delete_subscriber(subscriber)
      {:error, %Ecto.Changeset{}}

  """
  def delete_subscriber(%Subscriber{} = subscriber) do
    Repo.delete(subscriber)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking subscriber changes.

  ## Examples

      iex> change_subscriber(subscriber)
      %Ecto.Changeset{source: %Subscriber{}}

  """
  def change_subscriber(%Subscriber{} = subscriber) do
    Subscriber.changeset(subscriber, %{})
  end

  alias Nfd.Account.ContactForm

  @doc """
  Returns the list of contact_form.

  ## Examples

      iex> list_contact_form()
      [%ContactForm{}, ...]

  """
  def list_contact_form do
    Repo.all(ContactForm)
  end

  @doc """
  Gets a single contact_form.

  Raises `Ecto.NoResultsError` if the Contact form does not exist.

  ## Examples

      iex> get_contact_form!(123)
      %ContactForm{}

      iex> get_contact_form!(456)
      ** (Ecto.NoResultsError)

  """
  def get_contact_form!(id), do: Repo.get!(ContactForm, id)

  @doc """
  Creates a contact_form.

  ## Examples

      iex> create_contact_form(%{field: value})
      {:ok, %ContactForm{}}

      iex> create_contact_form(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_contact_form(attrs \\ %{}) do
    %ContactForm{}
    |> ContactForm.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a contact_form.

  ## Examples

      iex> update_contact_form(contact_form, %{field: new_value})
      {:ok, %ContactForm{}}

      iex> update_contact_form(contact_form, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_contact_form(%ContactForm{} = contact_form, attrs) do
    contact_form
    |> ContactForm.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ContactForm.

  ## Examples

      iex> delete_contact_form(contact_form)
      {:ok, %ContactForm{}}

      iex> delete_contact_form(contact_form)
      {:error, %Ecto.Changeset{}}

  """
  def delete_contact_form(%ContactForm{} = contact_form) do
    Repo.delete(contact_form)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking contact_form changes.

  ## Examples

      iex> change_contact_form(contact_form)
      %Ecto.Changeset{source: %ContactForm{}}

  """
  def change_contact_form(%ContactForm{} = contact_form) do
    ContactForm.changeset(contact_form, %{})
  end
end
