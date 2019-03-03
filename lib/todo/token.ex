defmodule Todo.Token do
  alias Todo.Cache

  @timeout 1200

  def generate_and_cache_token(user_id) do
    Cache.start_link()

    token =
      generate_token()
      |> cache_token(user_id)

    {:ok, token}
  end

  def get_token(token) do
    Cache.start_link()

    token = String.replace(token, ~r/"/, "") |> format_token()

    case user_id = Cache.get(token) do
      nil -> {:not_found}
      _ -> {:ok, user_id}
    end
  end

  defp generate_token do
    {:ok, token_generator} = fetch_token_generator()
    token_generator.()
  end

  defp cache_token(token, user_id) do
    token
    |> format_token()
    |> Cache.setex(@timeout, user_id)

    token
  end

  defp format_token(token) when not is_nil(token) do
    "token.#{token}"
  end

  defp fetch_token_generator do
    with nil <- Application.get_env(:todo, :token_generator) do
      {:error, "Configure a token_generator in config/config.exs"}
    else
      fun -> {:ok, fun}
    end
  end
end
