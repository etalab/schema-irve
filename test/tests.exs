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

  # table schema standard properties, plus `arrayItem` frictionless extension.
  @field_keys ~w(name type format title description example constraints rdfType missingValues arrayItem)
  @constraint_keys ~w(required unique minLength maxLength minimum maximum pattern enum)

  defp read_json!(path), do: path |> File.read!() |> JSON.decode!()

  defp assert_known_keys!(descriptor, allowed, context) do
    for key <- Map.keys(descriptor), not String.starts_with?(key, "x-") do
      assert key in allowed,
             "#{context}: unknown property #{inspect(key)}, silently ignored by validators"
    end
  end

  defp assert_known_field_keys!(descriptor, context) do
    assert_known_keys!(descriptor, @field_keys, context)
    assert_known_keys!(Map.get(descriptor, "constraints", %{}), @constraint_keys, "#{context} constraints")
  end

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

    test "#{path}: every field only declares known properties" do
      for field <- read_json!(@path) |> Map.fetch!("fields") do
        assert_known_field_keys!(field, "field #{field["name"]}")

        if item = field["arrayItem"] do
          assert_known_field_keys!(item, "field #{field["name"]} arrayItem")
        end
      end
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
