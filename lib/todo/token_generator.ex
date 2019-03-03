defmodule Todo.TokenGenerator do
  alias Todo.Cache

  def generate_and_cache_token(user_id) do
    {:ok, token_generator} = fetch_token_generator()
    token = token_generator.()

    Cache.start_link()
    Cache.setex("token.#{token}", 1200, user_id)

    {:ok, token}
  end

  def get_token(token) do
    Cache.start_link()
    Cache.get("token.#{token}")
  end

  defp fetch_token_generator do
    with nil <- Application.get_env(:todo, :token_generator) do
      {:error, "Configure a token_generator in config/config.exs"}
    else
      fun -> {:ok, fun}
    end
  end
end
