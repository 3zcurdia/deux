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
    assert Report.diff(a, b) == {:error, %{adds: [:a], subs: [:a], distance: 1}}
  end

  test "must return error tupole on different strings" do
    a = "cat"
    b = "rar"
    assert Report.diff(a, b) == {:error, %{adds: b, subs: a, distance: 2}}
  end

  test "must return error tupole on different atoms" do
    a = :foo
    b = :bar
    assert Report.diff(a, b) == {:error, %{adds: b, subs: a, distance: 2}}
  end

  test "must return error tupole on different integers" do
    a = 1
    b = 2
    assert Report.diff(a, b) == {:error, %{adds: b, subs: a, distance: 1}}
  end
end
