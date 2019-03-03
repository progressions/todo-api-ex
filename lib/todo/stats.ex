defmodule Todo.Stats do
  require DogStatsd

  def increment(stat) do
    {api, pid} = client()
    api.increment(pid, formatted_stat(stat))
  end

  defp client do
    with {:ok, config} <- config(),
         api <- Keyword.get(config, :api),
         port <- Keyword.get(config, :port),
         host <- Keyword.get(config, :host),
         {:ok, pid} <- api.new(host, port) do
           {api, pid}
    end
  end

  defp formatted_stat(stat), do: "#{Application.get_env(:todo, :mix_env)}.#{stat}"

  def config, do: {:ok, Application.get_env(:todo, :dogstatsd)}
end
