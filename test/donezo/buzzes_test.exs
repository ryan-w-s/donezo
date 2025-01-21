defmodule Donezo.BuzzesTest do
  use Donezo.DataCase

  alias Donezo.Buzzes

  describe "buzzes" do
    alias Donezo.Buzzes.Buzz

    import Donezo.BuzzesFixtures

    @invalid_attrs %{title: nil, completed: nil, completed_at: nil}

    test "list_buzzes/0 returns all buzzes" do
      buzz = buzz_fixture()
      assert Buzzes.list_buzzes() == [buzz]
    end

    test "get_buzz!/1 returns the buzz with given id" do
      buzz = buzz_fixture()
      assert Buzzes.get_buzz!(buzz.id) == buzz
    end

    test "create_buzz/1 with valid data creates a buzz" do
      valid_attrs = %{title: "some title", completed: true, completed_at: ~U[2025-01-20 11:36:00Z]}

      assert {:ok, %Buzz{} = buzz} = Buzzes.create_buzz(valid_attrs)
      assert buzz.title == "some title"
      assert buzz.completed == true
      assert buzz.completed_at == ~U[2025-01-20 11:36:00Z]
    end

    test "create_buzz/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Buzzes.create_buzz(@invalid_attrs)
    end

    test "update_buzz/2 with valid data updates the buzz" do
      buzz = buzz_fixture()
      update_attrs = %{title: "some updated title", completed: false, completed_at: ~U[2025-01-21 11:36:00Z]}

      assert {:ok, %Buzz{} = buzz} = Buzzes.update_buzz(buzz, update_attrs)
      assert buzz.title == "some updated title"
      assert buzz.completed == false
      assert buzz.completed_at == ~U[2025-01-21 11:36:00Z]
    end

    test "update_buzz/2 with invalid data returns error changeset" do
      buzz = buzz_fixture()
      assert {:error, %Ecto.Changeset{}} = Buzzes.update_buzz(buzz, @invalid_attrs)
      assert buzz == Buzzes.get_buzz!(buzz.id)
    end

    test "delete_buzz/1 deletes the buzz" do
      buzz = buzz_fixture()
      assert {:ok, %Buzz{}} = Buzzes.delete_buzz(buzz)
      assert_raise Ecto.NoResultsError, fn -> Buzzes.get_buzz!(buzz.id) end
    end

    test "change_buzz/1 returns a buzz changeset" do
      buzz = buzz_fixture()
      assert %Ecto.Changeset{} = Buzzes.change_buzz(buzz)
    end
  end
end
