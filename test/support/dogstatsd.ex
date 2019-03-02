defmodule Todo.DogStatsd.Test do
  def new(_host, _localhost), do: %{}

  def increment(_client, key) do
    send self(), {:increment, key}
  end
end
