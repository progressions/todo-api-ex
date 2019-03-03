defmodule TodoWeb.Plugs.TokenAuth do
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    with ["Token token=" <> token] <- get_req_header(conn, "authorization"),
         {:ok, user_id} <- Todo.Token.get_token(token) do
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
end
