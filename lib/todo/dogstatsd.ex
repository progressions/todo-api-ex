defmodule Todo.DogStatsd do
  require DogStatsd

  def client do
    {:ok, _statsd} = DogStatsd.new("localhost", 8125)
  end
end
