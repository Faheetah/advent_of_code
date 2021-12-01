defmodule TwentyTwentyOne.AocTest do
  use ExUnit.Case
  alias TwentyTwentyOne.Aoc

  @test_pulses "1\n2\n3\n2"

  test "parse_pulses/1" do
    expected = [{1, 0}, {2, 1}, {3, 1}, {2, -1}]
    got = Aoc.parse_pulses(@test_pulses)
    assert expected == got
  end

  test "count_pulse_increases/1" do
    expected = 2

    got =
      @test_pulses
      |> Aoc.parse_pulses()
      |> Aoc.count_pulse_increases()

    assert expected == got
  end
end
