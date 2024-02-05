Mix.install([
  {:jason, "~> 1.4"},
  {:req, "~> 0.4.8"}
])

defmodule Deadlinks do
  # scan an Elixir structure to find links
  def scan(x) when is_list(x) or is_map(x) do
    x
    |> Enum.map(&scan(&1))
    |> List.flatten()
    |> Enum.reject(&is_nil(&1))
  end

  def scan(x) when is_tuple(x), do: scan(x |> Tuple.to_list())
  def scan(value = "http" <> _), do: value
  def scan(_), do: nil
end

broken_json_links =
  "**/*.json"
  |> Path.wildcard()
  |> Enum.map(fn x ->
    x
    |> File.read!()
    |> Jason.decode!()
  end)
  |> Deadlinks.scan()
  |> Enum.uniq()
  |> Enum.map(fn x ->
    Req.head!(x)
    |> Map.take([:status])
    |> Map.put(:url, x)
  end)
  |> Enum.reject(fn %{status: x} -> x == 200 end)

unless broken_json_links == [] do
  IO.puts("Some links are broken, please fix them:\n")
  IO.puts(broken_json_links |> Enum.map(&inspect(&1)) |> Enum.join("\n"))
  System.halt(1)
end
