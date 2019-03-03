defmodule Todo.TokenTest do
  alias Todo.Token

  use ExUnit.Case

  @user_id "890b69cf-c09a-4e4f-a5f3-9275a3763d51"

  test "generate_and_cache_token" do
    {:ok, token} = Token.generate_and_cache_token(@user_id)
    assert Token.get_token(token) == {:ok, @user_id}
  end

  test "raises an error if there's no generator configured" do
    generator = Application.get_env(:todo, :token_generator)
    Application.put_env(:todo, :token_generator, nil)

    assert_raise MatchError, fn ->
      Token.generate_and_cache_token(@user_id)
    end

    Application.put_env(:todo, :token_generator, generator)
  end
end
