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

# URLs that are known to have Cloudflare protection or other anti-bot measures
# These will be skipped in automated checks but should be manually verified
cloudflare_protected_domains = [
  "legifrance.gouv.fr"
]

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
    # Skip URLs from protected domains to avoid false positives in CI
    if Enum.any?(cloudflare_protected_domains, &String.contains?(x, &1)) do
      IO.puts("Skipping Cloudflare-protected URL (manual verification needed): #{x}")
      %{status: 200, url: x, skipped: true}  # Mark as OK to avoid CI failure
    else
      Req.head!(x)
      |> Map.take([:status])
      |> Map.put(:url, x)
    end
  end)
  |> Enum.reject(fn %{status: x} -> x == 200 end)

unless broken_json_links == [] do
  IO.puts("Some links are broken, please fix them:\n")
  IO.puts(broken_json_links |> Enum.map(&inspect(&1)) |> Enum.join("\n"))
  System.halt(1)
end
