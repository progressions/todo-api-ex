defmodule TodoWeb.Plugs.TokenAuth do
  import Plug.Conn

  alias Todo.Cache

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    get_req_header(conn, "authorization")
    |> handle_request(conn)
  end

  defp handle_request(["Token token=" <> token], conn) do
    if user_id = find_user_id(token) do
      conn
      |> put_session(:user_id, user_id)
    else
      unauthorized(conn)
    end
  end
  defp handle_request(_, conn), do: unauthorized(conn)

  defp unauthorized(conn) do
    conn
    |> send_resp(401, "unauthorized")
    |> halt
  end

  defp find_user_id(token) do
    token = String.replace(token, ~r/"/, "")
    Cache.start_link()
    user_id = Cache.get("token.#{token}")

    case user_id do
      {:not_found} -> false
      _ -> user_id
    end
  end
end
