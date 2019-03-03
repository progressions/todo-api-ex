defmodule Todo.Stats do
  require DogStatsd

  def increment(stat) do
    {api, statsd_client} = client()
    api.increment(statsd_client, formatted_stat(stat))
  end

  defp client do
    with {:ok, config} <- config(),
         api <- Keyword.get(config, :api),
         port <- Keyword.get(config, :port),
         host <- Keyword.get(config, :host),
         {:ok, statsd_client} <- api.new(host, port) do
           {api, statsd_client}
    end
  end

  defp formatted_stat(stat), do: "#{Application.get_env(:todo, :mix_env)}.#{stat}"

  def config, do: {:ok, Application.get_env(:todo, :dogstatsd)}
end
