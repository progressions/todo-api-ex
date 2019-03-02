defmodule TodoWeb.Plugs.BasicAuthTest do
  use TodoWeb.ConnCase
  use Plug.Test

  @encrypted_username_password "dXNlcm5hbWU6cGFzc3dvcmQ="

  alias TodoWeb.Plugs.BasicAuth

  test "with invalid header, return a 401 status", %{conn: conn} do
    conn =
      conn
      |> init_test_session(%{})
      |> with_invalid_authorization_header()
      |> BasicAuth.call(%{})

    assert conn.status == 401
  end

  test "with valid header, assign current user to the session", %{conn: conn} do
    conn =
      conn
      |> init_test_session(%{})
      |> with_valid_authorization_header()
      |> BasicAuth.call(%{})

    assert conn.assigns.current_user.encrypted_username_password == @encrypted_username_password
  end
end
