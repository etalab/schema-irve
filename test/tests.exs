Mix.install([{:ex_json_schema, "~> 0.10"}])

ExUnit.start()

defmodule SchemaIrveTest do
  use ExUnit.Case

  defp read_json!(path), do: path |> File.read!() |> JSON.decode!()

  test "statique JSON is valid" do
    read_json!("statique/schema-statique.json")
  end

  test "dynamique JSON is valid" do
    read_json!("dynamique/schema-dynamique.json")
  end

  test "statique-tarifs JSON is valid" do
    read_json!("statique-tarifs/schema-statique-tarifs.json")
  end

  test "restrictions is a valid JSON Schema" do
    schema = read_json!("statique-tarifs/restrictions.schema.json") |> ExJsonSchema.Schema.resolve()
    assert %ExJsonSchema.Schema.Root{} = schema
  end

  test "price-components is a valid JSON Schema" do
    schema = read_json!("statique-tarifs/price-components.schema.json") |> ExJsonSchema.Schema.resolve()
    assert %ExJsonSchema.Schema.Root{} = schema
  end
end
