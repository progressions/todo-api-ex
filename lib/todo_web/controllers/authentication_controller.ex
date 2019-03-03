defmodule TodoWeb.AuthenticationController do
  use TodoWeb, :controller
  use Timex

  def authenticate(conn, _params) do
    with user <- Todo.UserSession.current_user(conn),
         {:ok, token} <- Todo.Token.generate_and_cache_token(user.id) do
      Todo.Stats.increment("user.authenticate")

      render(conn, "authenticate.json", %{
        token: token,
        expires_at: expires_at()
      })
    end
  end

  defp expires_at do
    Timex.now()
    |> Timex.add(Duration.from_minutes(20))
    |> case do
      {:ok, date} -> DateTime.to_string(date)
      _ -> nil
    end
  end
end
