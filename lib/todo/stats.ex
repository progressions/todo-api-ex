defmodule Todo.Stats do
  require DogStatsd

  @dogstatsd_api Application.get_env(:todo, :dogstatsd)[:api]

  def increment(stat) do
    client()
    |> @dogstatsd_api.increment(formatted_stat(stat))
  end

  defp client do
    with {:ok, [host: host, port: port]} <- config(),
         {:ok, statsd} <- @dogstatsd_api.new(host, port) do
      statsd
    end
  end

  defp formatted_stat(stat), do: "#{Application.get_env(:todo, :mix_env)}.#{stat}"

  def config, do: {:ok, Application.get_env(:todo, :dogstatsd)}
end
