defmodule Todo.TokenTest do
  alias Todo.Token

  use ExUnit.Case

  @user_id "890b69cf-c09a-4e4f-a5f3-9275a3763d51"

  test "generate_and_cache_token" do
    {:ok, token} = Token.generate_and_cache_token(@user_id)
    assert Token.get_token(token) == {:ok, @user_id}
  end

  test "raises an error if there's no generator configured" do
    with_token_generator(nil, fn ->
      assert_raise MatchError, fn ->
        Token.generate_and_cache_token(@user_id)
      end
    end)
  end

  test "uses a different generator" do
    gen = fn -> "1234" end

    with_token_generator(gen, fn ->
      assert Token.generate_and_cache_token(@user_id) == {:ok, "1234"}
    end)
  end

  def with_token_generator(new_generator, fun) do
    original = Application.get_env(:todo, :token_generator)
    Application.put_env(:todo, :token_generator, new_generator)

    fun.()

    Application.put_env(:todo, :token_generator, original)
  end
end
