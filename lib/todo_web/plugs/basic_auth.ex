defmodule TodoWeb.Plugs.BasicAuth do
  import Plug.Conn

  alias Todo.User

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    get_req_header(conn, "authorization")
    |> handle_request(conn)
  end

  defp handle_request(["Basic " <> auth], conn) do
    find_user(auth)
    |> assign_current_user(conn)
  end

  defp handle_request(_, conn), do: unauthorized(conn)

  defp assign_current_user(user = %User{}, conn) do
    conn
    |> put_session(:user_id, user.id)
    |> assign(:current_user, user)
  end

  defp assign_current_user(_, conn), do: unauthorized(conn)

  defp unauthorized(conn) do
    conn
    |> send_resp(401, "unauthorized")
    |> halt
  end

  defp find_user(auth) do
    Todo.Repo.get_by(User, encrypted_username_password: auth)
  end
end
