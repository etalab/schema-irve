ExUnit.start()

defmodule SchemaIrveTest do
  use ExUnit.Case

  test "statique JSON is valid" do
    assert {:ok, _} = "statique/schema-statique.json" |> File.read!() |> JSON.decode()
  end

  test "dynamique JSON is valid" do
    assert {:ok, _} = "dynamique/schema-dynamique.json" |> File.read!() |> JSON.decode()
  end

  test "statique-tarifs JSON is valid" do
    assert {:ok, _} = "statique-tarifs/schema-statique-tarifs.json" |> File.read!() |> JSON.decode()
  end

  test "restrictions JSON Schema is valid" do
    assert {:ok, _} = "statique-tarifs/restrictions.schema.json" |> File.read!() |> JSON.decode()
  end

  test "price-components JSON Schema is valid" do
    assert {:ok, _} = "statique-tarifs/price-components.schema.json" |> File.read!() |> JSON.decode()
  end
end
