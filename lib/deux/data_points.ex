defmodule Deux.DataPoints do
  @moduledoc """
  List abstraction to store with a max limit
  """
  defstruct values: [], limit: 2_000

  @doc """
  It adds a value to a data_points if the length is below the max limit,
  otherwise it will discard the last value and add the new one

  ## Examples

     iex> points = %Deux.DataPoints{limit: 3, values: [1,2,3]}
     iex> Deux.DataPoints.add(points, 4)
     %Deux.DataPoints{limit: 3, values: [4,1,2]}
  """
  def add(%Deux.DataPoints{limit: limit, values: values} = data_points, value) do
    if length(values) < limit do
      %Deux.DataPoints{data_points | values: [value | values]}
    else
      data_points |> discard_last |> add(value)
    end
  end

  @doc """
  Discard the last value from the values list

  ## Examples

      iex> Deux.DataPoints.discard_last(%Deux.DataPoints{values: [1,2,3]})
      %Deux.DataPoints{values: [1,2], limit: 2_000}
  """
  def discard_last(%Deux.DataPoints{values: values} = data_points) do
    {_, values} = List.pop_at(values, length(values) - 1)
    %Deux.DataPoints{data_points | values: values}
  end
end
