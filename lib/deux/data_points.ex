defmodule Deux.DataPoints do
  defstruct values: [], limit: 2_000
  alias Deux.DataPoints

  def add(%DataPoints{limit: limit, values: values} = data_points, value) do
    if length(values) < limit do
      %DataPoints{data_points | values: [value | values]}
    else
      data_points |> discard_last |> add(value)
    end
  end

  def discard_last(%DataPoints{values: values} = data_points) do
    {_, values} = List.pop_at(values, length(values) - 1)
    %DataPoints{data_points | values: values}
  end
end
