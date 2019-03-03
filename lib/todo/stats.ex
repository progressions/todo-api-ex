defmodule Todo.Stats do
  require DogStatsd

  def increment(stat) do
    {api, statsd} = client()
    api.increment(statsd, formatted_stat(stat))
  end

  def client do
    with {:ok, config} <- config(),
         api <- config[:api],
         port <- config[:port],
         host <- config[:host],
         {:ok, statsd} <- api.new(host, port) do
           {api, statsd}
    end
  end

  defp formatted_stat(stat), do: "#{Application.get_env(:todo, :mix_env)}.#{stat}"

  def config, do: {:ok, Application.get_env(:todo, :dogstatsd)}
end
