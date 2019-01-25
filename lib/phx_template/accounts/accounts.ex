defmodule PhxTemplate.Accounts do
  @moduledoc """
  The Account context.
  """

  alias PhxTemplate.Accounts.User
  alias PhxTemplate.Repo

  @spec create_user(map()) :: any()
  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @spec list_users() :: any()
  def list_users do
    Repo.all(User)
  end
end
