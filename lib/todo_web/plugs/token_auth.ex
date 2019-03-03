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

  defp assign_current_user(user_id, conn) do
    conn
    |> put_session(:user_id, user_id)
  end

  defp unauthorized(conn) do
    conn
    |> send_resp(401, "unauthorized")
    |> halt
  end

  defp find_user_id(token) do
    Cache.start_link()

    token = String.replace(token, ~r/"/, "")

    case user_id = Cache.get("token.#{token}") do
      nil -> {:not_found}
      _ -> {:ok, user_id}
    end
  end
end
