Mix.install([{:ex_json_schema, "~> 0.10"}])

ExUnit.start(trace: true)

defmodule SchemaIrveTest do
  use ExUnit.Case

  @schemas [
    "statique/schema-statique.json",
    "dynamique/schema-dynamique.json",
    "statique-tarifs/schema-statique-tarifs.json"
  ]

  @entities ["pdc", "station", "tarif", "tarif_element"]

  defp read_json!(path), do: path |> File.read!() |> JSON.decode!()

  defp tarif_field_example!(name) do
    read_json!("statique-tarifs/schema-statique-tarifs.json")
    |> Map.fetch!("fields")
    |> Enum.find(&(&1["name"] == name))
    |> Map.fetch!("example")
    |> JSON.decode!()
  end

  defp resolve_schema!(path), do: read_json!(path) |> ExJsonSchema.Schema.resolve()

  for path <- @schemas do
    @path path

    test "#{path} JSON is valid" do
      read_json!(@path)
    end

    test "#{path}: every field carries a valid x-entity" do
      for field <- read_json!(@path) |> Map.fetch!("fields") do
        assert field["x-entity"] in @entities,
               "champ #{field["name"]} sans x-entity valide (trouvé : #{inspect(field["x-entity"])})"
      end
    end
  end

  test "restrictions is a valid JSON Schema" do
    assert %ExJsonSchema.Schema.Root{} = resolve_schema!("statique-tarifs/restrictions.schema.json")
  end

  test "price-components is a valid JSON Schema" do
    assert %ExJsonSchema.Schema.Root{} = resolve_schema!("statique-tarifs/price-components.schema.json")
  end

  test "restrictions example follows its own schema" do
    schema = resolve_schema!("statique-tarifs/restrictions.schema.json")
    assert :ok = ExJsonSchema.Validator.validate(schema, tarif_field_example!("restrictions"))
  end

  test "price_components example follows its own schema" do
    schema = resolve_schema!("statique-tarifs/price-components.schema.json")
    assert :ok = ExJsonSchema.Validator.validate(schema, tarif_field_example!("price_components"))
  end
end
