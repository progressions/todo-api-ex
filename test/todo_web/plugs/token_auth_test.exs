defmodule TodoWeb.Plugs.TokenAuthTest do
  use TodoWeb.ConnCase
  use Plug.Test

  alias TodoWeb.Plugs.TokenAuth

  test "with no authorization token, the response is a 401", %{conn: conn} do
    conn =
      conn
      |> init_test_session(%{})
      |> with_invalid_auth_token_header()
      |> TokenAuth.call(%{})

    assert conn.status == 401
    assert conn.assigns[:user_id] == nil
  end

  test "with a valid authorization token, the session contains the user's user ID", %{conn: conn} do
    conn =
      conn
      |> init_test_session(%{})
      |> with_valid_auth_token_header()
      |> TokenAuth.call(%{})

    assert conn.assigns.user_id != nil
  end
end
