defmodule TodoWeb.Plugs.TokenAuth do
  import Plug.Conn

  alias Todo.Cache

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    with ["Token token=" <> token] <- get_req_header(conn, "authorization"),
         {:ok, user_id} <- find_user_id(token) do
      assign_current_user(user_id, conn)
    else
      _ -> unauthorized(conn)
    end
  end

  defp assign_current_user(user_id, conn) when not is_nil(user_id) do
    conn
    |> put_session(:user_id, user_id)
  end

  defp assign_current_user(_, conn), do: unauthorized(conn)

  defp unauthorized(conn) do
    conn
    |> send_resp(401, "unauthorized")
    |> halt
  end

  defp find_user_id(token) do
    Cache.start_link()

    token = String.replace(token, ~r/"/, "")
    user_id = Cache.get("token.#{token}")

    case user_id do
      {:not_found} -> nil
      _ -> {:ok, user_id}
    end
  end
end
