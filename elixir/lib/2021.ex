defmodule TwentyTwentyOne.Aoc do
  @moduledoc "Advent of Code for year 2021"

  @doc """
  Parse a list of pulses with a comparison to the last pulse
  given an input as a string of newline separated pulses
  """
  def parse_pulses(input) do
    input
    |> String.split()
    |> Enum.reduce([], fn pulse, acc ->
      parsed_pulse = parse_pulse(pulse)
      [{parsed_pulse, compare_last(acc, parsed_pulse)} | acc]
    end)
    |> Enum.reverse()
  end

  defp compare_last([], _), do: 0
  defp compare_last([last | _], current), do: current - elem(last, 0)

  defp parse_pulse(pulse) do
    pulse
    |> Integer.parse()
    |> elem(0)
  end

  @doc """
  Count the amount of pulses that have a positive increase
  """
  def count_pulse_increases(pulses) do
    Enum.count(pulses, fn {_, p} -> p > 0 end)
  end
end
