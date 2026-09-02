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

  @telephone_cases [
    {"+33 0199000000", :valid, "France, leading zero kept"},
    {"+33 0199000000-12", :valid, "extension after a hyphen"},
    {"+352 25363640", :valid, "country without trunk prefix (Luxembourg)"},
    {"+1 2125550100", :valid, "1-digit country code"},
    {"0199000000", :invalid, "missing country code"},
    {"0033 0199000000", :invalid, "country code without +"},
    {"+330199000000", :invalid, "missing space after country code"},
    {"+33 01 99 00 00 00", :invalid, "spaces inside the number"},
    {"+33 01-99-00-00-00", :invalid, "hyphens inside the number"},
    {"+33 (0)199000000", :invalid, "parentheses"},
    {"+33 0199000000 -12", :invalid, "extension not attached to the number"},
    {"tel:+33-1-99-00-00-00", :invalid, "tel: URI (RFC 3966)"},
    {"+33 0199000000 ", :invalid, "trailing space"},
    {"+33 ٠١٩٩٠٠٠٠٠٠", :invalid, "non-ASCII digits"},
    {"", :invalid, "empty"}
  ]

  defp read_json!(path), do: path |> File.read!() |> JSON.decode!()

  defp field!(path, name) do
    read_json!(path) |> Map.fetch!("fields") |> Enum.find(&(&1["name"] == name)) ||
      raise "field #{name} not found in #{path}"
  end

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

  defp frictionless_verdicts!(schema, fixture, field, values) do
    [header, row | _] = fixture |> File.read!() |> String.split("\n", trim: true)
    example = field!(schema, field)["example"]

    rows =
      for {value, i} <- Enum.with_index(values) do
        row
        |> String.replace(",#{example},", ",#{value},")
        |> String.replace("FRA68E680210015", "FRA68E6802100#{15 + i}")
      end

    csv = "test/tmp-#{System.unique_integer([:positive])}.csv"
    File.write!(csv, Enum.join([header | rows], "\n") <> "\n")
    {output, _} = System.cmd("uv", ~w(run frictionless validate --schema #{schema} --json #{csv}))
    File.rm!(csv)

    errors = output |> JSON.decode!() |> get_in(["tasks", Access.at(0), "errors"])
    refute Enum.find(errors, &is_nil(&1["rowNumber"]))

    for i <- 2..(length(values) + 1) do
      if Enum.any?(errors, &(&1["rowNumber"] == i and &1["fieldName"] == field)), do: :invalid, else: :valid
    end
  end

  test "telephone_operateur pattern (AFIR A5) evaluated by frictionless" do
    values = Enum.map(@telephone_cases, &elem(&1, 0))
    verdicts = frictionless_verdicts!("statique/schema-statique.json", "statique/exemple-valide-statique.csv", "telephone_operateur", values)

    for {{value, expected, reason}, actual} <- Enum.zip(@telephone_cases, verdicts) do
      assert actual == expected, "#{inspect(value)} (#{reason})"
    end
  end

  for {value, expected, reason} <- @telephone_cases do
    @value value
    @expected expected

    test "telephone_operateur pattern (AFIR A5) evaluated by Elixir Regex: #{inspect(value)} is #{expected} (#{reason})" do
      pattern = field!("statique/schema-statique.json", "telephone_operateur")["constraints"]["pattern"]
      assert Regex.match?(~r/#{pattern}/, @value) == (@expected == :valid)
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
