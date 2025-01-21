defmodule DonezoWeb.BuzzLiveTest do
  use DonezoWeb.ConnCase

  import Phoenix.LiveViewTest
  import Donezo.BuzzesFixtures

  @create_attrs %{title: "some title", completed: true, completed_at: "2025-01-20T11:36:00Z"}
  @update_attrs %{title: "some updated title", completed: false, completed_at: "2025-01-21T11:36:00Z"}
  @invalid_attrs %{title: nil, completed: false, completed_at: nil}

  defp create_buzz(_) do
    buzz = buzz_fixture()
    %{buzz: buzz}
  end

  describe "Index" do
    setup [:create_buzz]

    test "lists all buzzes", %{conn: conn, buzz: buzz} do
      {:ok, _index_live, html} = live(conn, ~p"/buzzes")

      assert html =~ "Listing Buzzes"
      assert html =~ buzz.title
    end

    test "saves new buzz", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/buzzes")

      assert index_live |> element("a", "New Buzz") |> render_click() =~
               "New Buzz"

      assert_patch(index_live, ~p"/buzzes/new")

      assert index_live
             |> form("#buzz-form", buzz: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#buzz-form", buzz: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/buzzes")

      html = render(index_live)
      assert html =~ "Buzz created successfully"
      assert html =~ "some title"
    end

    test "updates buzz in listing", %{conn: conn, buzz: buzz} do
      {:ok, index_live, _html} = live(conn, ~p"/buzzes")

      assert index_live |> element("#buzzes-#{buzz.id} a", "Edit") |> render_click() =~
               "Edit Buzz"

      assert_patch(index_live, ~p"/buzzes/#{buzz}/edit")

      assert index_live
             |> form("#buzz-form", buzz: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#buzz-form", buzz: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/buzzes")

      html = render(index_live)
      assert html =~ "Buzz updated successfully"
      assert html =~ "some updated title"
    end

    test "deletes buzz in listing", %{conn: conn, buzz: buzz} do
      {:ok, index_live, _html} = live(conn, ~p"/buzzes")

      assert index_live |> element("#buzzes-#{buzz.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#buzzes-#{buzz.id}")
    end
  end

  describe "Show" do
    setup [:create_buzz]

    test "displays buzz", %{conn: conn, buzz: buzz} do
      {:ok, _show_live, html} = live(conn, ~p"/buzzes/#{buzz}")

      assert html =~ "Show Buzz"
      assert html =~ buzz.title
    end

    test "updates buzz within modal", %{conn: conn, buzz: buzz} do
      {:ok, show_live, _html} = live(conn, ~p"/buzzes/#{buzz}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Buzz"

      assert_patch(show_live, ~p"/buzzes/#{buzz}/show/edit")

      assert show_live
             |> form("#buzz-form", buzz: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#buzz-form", buzz: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/buzzes/#{buzz}")

      html = render(show_live)
      assert html =~ "Buzz updated successfully"
      assert html =~ "some updated title"
    end
  end
end
