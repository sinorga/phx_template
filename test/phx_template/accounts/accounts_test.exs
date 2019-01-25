defmodule PhxTemplate.AccountsTest do
  use PhxTemplate.DataCase

  alias PhxTemplate.Accounts
  alias PhxTemplate.Accounts.User

  describe "create_user/2" do
    @valid_attrs %{
      name: "Bob",
      username: "Uncle Bob"
    }

    @invalid_attrs %{}

    test "with valid data inserts user" do
      assert {:ok, %User{id: id} = user} = Accounts.create_user(@valid_attrs)
      assert user.name == "Bob"
      assert user.username == "Uncle Bob"
      assert [%User{id: ^id}] = Accounts.list_users()
    end

    test "with invalid data does not insert user" do
      assert {:error, _changeset} = Accounts.create_user(@invalid_attrs)
      assert Accounts.list_users() == []
    end
  end
end
