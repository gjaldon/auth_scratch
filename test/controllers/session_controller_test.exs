defmodule AuthScratch.SessionControllerTest do
  use AuthScratch.ConnCase
  alias AuthScratch.User

  setup do
    user = Repo.insert!(User.changeset(%User{}, %{email: "foo@bar.com", password: "foobar"}))
    {:ok, user: user}
  end

  test "signing in", %{user: user} do
    conn = post conn(), "/login", %{login: %{email: "foo@bar.com", password: "foobar"}}
    assert redirected_to(conn) == "/"
    assert get_session(conn, :user_id) == user.id
  end

  test "sign in with no password or email" do
    conn = post conn(), "/login", %{login: %{email: "foo@bar.com", password: nil}}
    assert html_response(conn, 200) =~ "You must provide an email or password"

    conn = post conn(), "/login", %{login: %{email: nil, password: "foobar"}}
    assert html_response(conn, 200) =~ "You must provide an email or password"
  end

  test "sign in with non-existent account" do
    conn = post conn(), "/login", %{login: %{email: "test@bar.com", password: "password"}}
    assert html_response(conn, 200) =~ "Account does not exist"
  end

  test "authentication fails" do
    conn = post conn(), "/login", %{login: %{email: "foo@bar.com", password: "password"}}
    assert html_response(conn, 200) =~ "Authentication failed. Password was incorrect."
  end

  test "signing out", %{user: user} do
    conn = post conn(), "/login", %{login: %{email: "foo@bar.com", password: "foobar"}}
    assert get_session(conn, :user_id) == user.id

    conn = delete conn, "/logout"
    assert redirected_to(conn) == "/"
    assert get_flash(conn, :info) == "Successfully signed out!"
    assert get_session(conn, :user_id) == nil
  end
end
