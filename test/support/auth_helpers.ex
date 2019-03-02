defmodule TodoWeb.AuthHelpers do
  alias Todo.Cache

  import Plug.Conn

  @encrypted_username_password "dXNlcm5hbWU6cGFzc3dvcmQ="

  def with_valid_authorization_header(conn) do
    Todo.Repo.delete_all(Todo.User)

    {:ok, _user} =
      Todo.Repo.insert(%Todo.User{encrypted_username_password: @encrypted_username_password})

    conn
    |> put_req_header("authorization", "Basic #{@encrypted_username_password}")
  end

  def with_invalid_authorization_header(conn) do
    conn
    |> put_req_header("authorization", "Basic notrealusernamepassword")
  end

  def with_valid_auth_token_header(conn), do: with_valid_auth_token_header(conn, create_user())

  def with_valid_auth_token_header(conn, user) do
    token = Ecto.UUID.generate()
    Cache.start_link()
    Cache.setex("token.#{token}", 1, user.id)

    conn
    |> assign(:user_id, user.id)
    |> put_req_header("authorization", "Token token=\"#{token}\"")
  end

  def with_invalid_auth_token_header(conn) do
    conn
    |> put_req_header("authorization", "Token token=\"#{Ecto.UUID.generate()}\"")
  end

  def create_user(username \\ "something", password \\ "password") do
    with {:ok, user} <-
           Todo.Repo.insert(%Todo.User{
             encrypted_username_password: Todo.User.encode(username, password)
           }) do
      user
    end
  end
end
