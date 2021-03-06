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

  @movements """
  forward 5
  down 5
  forward 8
  up 3
  down 8
  forward 2
  """

  test "move/1" do
    assert Aoc.move(@movements) == 150
  end

  test "move_with_aim/1" do
    assert Aoc.move_with_aim(@movements) == 900
  end

  @diagnostics """
  00100
  11110
  10110
  10111
  10101
  01111
  00111
  11100
  10000
  11001
  00010
  01010
  """

  test "diagnostics/2" do
    assert Aoc.diagnostics(@diagnostics, 5) == 198
  end

  test "life_support/1" do
    assert Aoc.life_support(@diagnostics) == 230
  end
end
