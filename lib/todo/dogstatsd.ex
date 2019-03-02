defmodule Todo.DogStatsd do
  require DogStatsd

  use GenServer

  def client do
    {:ok, _statsd} = DogStatsd.new("localhost", 8125)
  end

  def start_link(_opts \\ []) do
    GenServer.start_link(
      __MODULE__,
      [
        {:ets_table_name, :cache_table},
        {:log_limit, 1_000_000}
      ],
      name: DogStatsd
    )
  end

  def increment(stat) do
    GenServer.call(__MODULE__, {:increment, stat})
  end

  def handle_call({:increment, stat}, _from, state) do
    DogStatsd.increment(client(), stat)

    {:reply, value, state}
  end
end
