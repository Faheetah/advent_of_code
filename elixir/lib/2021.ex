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

  def move_with_aim(movements) do
    movements
    |> String.splitter("\n")
    |> Stream.reject(&(&1 == ""))
    |> Stream.map(&String.split/1)
    |> Stream.map(fn [k, v] -> {String.to_atom(k), elem(Integer.parse(v), 0)} end)
    |> Enum.reduce({0, 0, 0}, &do_move/2)
    |> then(fn {a, b, _} -> a * b end)
  end

  def do_move({:forward, amount}, {pos, depth, 0}), do: {pos + amount, depth, 0}
  def do_move({:forward, amount}, {pos, depth, aim}), do: {pos + amount, depth + amount * aim, aim}
  def do_move({:down, amount}, {pos, depth, aim}), do: {pos, depth, aim + amount}
  def do_move({:up, amount}, {pos, depth, aim}), do: {pos, depth, aim - amount}

  # Day 3

  def diagnostics(diags, width) do
    diags
    |> String.splitter("\n")
    |> Stream.reject(&(&1 == ""))
    |> Stream.map(&String.graphemes/1)
    |> Enum.zip_reduce([], &List.insert_at(&2, 0, &1))
    |> Stream.map(&Enum.frequencies/1)
    |> Stream.map(fn m -> Enum.max_by(m, &elem(&1, 1)) end)
    |> Stream.map(&elem(&1, 0))
    |> Enum.reverse()
    |> Enum.join()
    |> String.to_integer(2)
    |> then(& &1 * Bitwise.bxor(&1, Integer.pow(2, width) - 1))
  end

  def life_support(input) do
    diags =
      input
      |> String.splitter("\n")
      |> Stream.reject(&(&1 == ""))
      |> Enum.map(&String.graphemes/1)

    oxygen =
      do_life_support(diags, "1", &Enum.max_by/2)
      |> Enum.join()
      |> String.to_integer(2)

    scrubber =
      do_life_support(diags, "0", &Enum.min_by/2)
      |> Enum.join()
      |> String.to_integer(2)

    oxygen * scrubber
  end

  def do_life_support([[]], _, _), do: []
  def do_life_support([["0"], ["1" | _]], fallback, _), do: [fallback]
  def do_life_support([["1"], ["0" | _]], fallback, _), do: [fallback]
  def do_life_support(diags, fallback, fun) do
    Enum.reduce(diags, [], fn [bit | rest], acc ->
      [{bit, rest} | acc]
    end)
    |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
    |> fun.(fn {_, x} -> length(x) end)
    |> then(fn {n, d} -> [n | do_life_support(d, fallback, fun)] end)
  end
end
