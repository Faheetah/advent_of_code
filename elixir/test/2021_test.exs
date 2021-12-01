defmodule TwentyTwentyOne.AocTest do
  use ExUnit.Case
  alias TwentyTwentyOne.Aoc

  @test_pulses """
  199
  200
  208
  210
  200
  207
  240
  269
  260
  263
  """

  test "parse_pulses/2" do
    expected = [
      {199, nil},
      {200, nil},
      {208, 607},
      {210, 618},
      {200, 618},
      {207, 617},
      {240, 647},
      {269, 716},
      {260, 769},
      {263, 792}
    ]
    got = Aoc.parse_pulses(@test_pulses, 3)
    assert expected == got
  end

  test "count_pulse_increases/2" do
    expected = 5

    got = Aoc.count_pulse_increases(@test_pulses, 3)

    assert expected == got
  end

  test "count_pulse_increases/2" do
  end
end
