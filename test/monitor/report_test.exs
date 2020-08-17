defmodule Deux.ReportTest do
  use ExUnit.Case, async: true
  alias Deux.Report

  test "must be true with equal on maps" do
    a = %{a: 1}
    b = %{a: 1}
    assert Report.valid?(a, b)
  end

  test "must be false with different on maps" do
    a = %{a: 1}
    b = %{a: 2}
    refute Report.valid?(a, b)
  end

  test "must return ok tuple on equal maps" do
    a = %{a: 1}
    b = %{a: 1}
    assert Report.diff(a, b) == {:ok, %{}}
  end

  test "must return error tuple on different maps" do
    a = %{a: 1}
    b = %{a: 2}
    assert Report.diff(a, b) == {:error, %{adds: [a: 2], subs: [a: 1], distance: 1}}
  end
end
