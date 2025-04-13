defmodule LunchWeb.UserLiveTest do
  use LunchWeb.ConnCase

  import Lunch.AccountsFixtures
  import Phoenix.LiveViewTest

  @create_attrs %{email: unique_user_email(), name: "some name"}
  @update_attrs %{email: unique_user_email(), name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_user(_) do
    user = user_fixture()

    %{user: user}
  end

  describe "Index" do
    setup [:create_user]

    test "lists all users", %{conn: conn, user: user} do
      {:ok, _index_live, html} = live(conn, ~p"/ops/users")

      assert html =~ "Listing Users"
      assert html =~ user.name
    end

    test "saves new user", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/ops/users")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New User")
               |> render_click()
               |> follow_redirect(conn, ~p"/ops/users/new")

      assert render(form_live) =~ "New User"

      assert form_live
             |> form("#user-form", user: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#user-form", user: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/ops/users")

      html = render(index_live)
      assert html =~ "User created successfully"
      assert html =~ "some name"
    end

    test "updates user in listing", %{conn: conn, user: user} do
      {:ok, index_live, _html} = live(conn, ~p"/ops/users")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#users-#{user.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/ops/users/#{user}/edit")

      assert render(form_live) =~ "Edit User"

      assert form_live
             |> form("#user-form", user: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#user-form", user: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/ops/users")

      html = render(index_live)
      assert html =~ "User updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes user in listing", %{conn: conn, user: user} do
      {:ok, index_live, _html} = live(conn, ~p"/ops/users")

      assert index_live |> element("#users-#{user.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#users-#{user.id}")
    end
  end

  describe "Show" do
    setup [:create_user]

    test "displays user", %{conn: conn, user: user} do
      {:ok, _show_live, html} = live(conn, ~p"/ops/users/#{user}")

      assert html =~ "Show User"
      assert html =~ user.name
    end

    test "updates user and returns to show", %{conn: conn, user: user} do
      {:ok, show_live, _html} = live(conn, ~p"/ops/users/#{user}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/ops/users/#{user}/edit?return_to=show")

      assert render(form_live) =~ "Edit User"

      assert form_live
             |> form("#user-form", user: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#user-form", user: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/ops/users/#{user}")

      html = render(show_live)
      assert html =~ "User updated successfully"
      assert html =~ "some updated name"
    end
  end
end
