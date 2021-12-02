defmodule TwentyTwentyOne.Aoc do
  @moduledoc "Advent of Code for year 2021"

  @doc """
  Parse a list of pulses with a comparison to the last pulse
  given an input as a string of newline separated pulses
  """
  def parse_pulses(input, window) do
    input
    |> String.split()
    |> Enum.reduce([], fn pulse, acc ->
      parsed_pulse = parse_pulse(pulse)

      value =
        if length(acc) >= (window - 1) do
          add_last(Enum.take(acc, window - 1), parsed_pulse)
        end

      [{parsed_pulse, value} | acc]
    end)
    |> Enum.reverse()
  end

  defp add_last(last, parsed_pulse) do
    Enum.reduce(last, parsed_pulse, &compare_last/2)
  end

  defp compare_last([], _), do: nil
  defp compare_last({last, _}, current), do: current + last

  defp parse_pulse(pulse) do
    pulse
    |> Integer.parse()
    |> elem(0)
  end

  @doc """
  Count the amount of pulses that have a positive increase
  """
  def count_pulse_increases(input, window \\ 1) do
    input
    |> parse_pulses(window)
    |> Enum.map(fn {_, p} -> p end)
    |> Enum.reject(fn p -> p == nil end)
    |> Enum.reduce({0, nil}, &compare_last_count/2)
    |> elem(0)
  end

  defp compare_last_count(current, {count, nil}), do: {count, current}
  defp compare_last_count(current, {count, last}) when current <= last, do: {count, current}
  defp compare_last_count(current, {count, _}), do: {count + 1, current}

  def move(movements) do
    totals = movements
    |> String.splitter("\n")
    |> Stream.reject(&(&1 == ""))
    |> Stream.map(&String.split/1)
    |> Stream.map(fn [k, v] -> [String.to_atom(k), elem(Integer.parse(v), 0)] end)
    |> Enum.group_by(&hd/1, &tl/1)
    |> Enum.map(fn {k, v} -> {k, Enum.reduce(v, 0, fn [x], acc -> acc + x end)} end)
    totals[:forward] * abs(totals[:down] - totals[:up])
  end
end
