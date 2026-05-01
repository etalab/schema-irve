ExUnit.start()

defmodule SchemaIrveTest do
  use ExUnit.Case

  test "statique JSON is valid" do
    assert {:ok, _} = "statique/schema-statique.json" |> File.read!() |> JSON.decode()
  end

  test "dynamique JSON is valid" do
    assert {:ok, _} = "dynamique/schema-dynamique.json" |> File.read!() |> JSON.decode()
  end
end
