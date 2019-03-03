defmodule Todo.DogStatsd.Test do
  def new(_host, _localhost), do: {Todo.DogStatsd.Test, :mock_client}

  def increment(_client, key) do
    send(self(), {:increment, key})
  end
end
