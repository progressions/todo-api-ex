defmodule TodoWeb.Plugs.BasicAuth do
  import Plug.Conn

  alias Todo.User

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    with ["Basic " <> auth] <- get_req_header(conn, "authorization"),
         {:ok, user} <- find_user(auth) do
      assign_current_user(user, conn)
    else
      _ -> unauthorized(conn)
    end
  end

  defp assign_current_user(user = %User{}, conn) do
    conn
    |> put_session(:user_id, user.id)
    |> assign(:current_user, user)
  end

  defp unauthorized(conn) do
    conn
    |> send_resp(401, "unauthorized")
    |> halt
  end

  defp find_user(auth) do
    case user = Todo.Repo.get_by(User, encrypted_username_password: auth) do
      nil -> {:not_found}
      _ -> {:ok, user}
    end
  end
end
