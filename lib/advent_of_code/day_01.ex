defmodule AdventOfCode.Day01 do
  @moduledoc """

  This Elixir line of code uses the `Regex.scan` function to find all
  overlapping matches in a string for the given regular expression pattern.

  - `~r` - This is Elixir's sigil for creating a regular expression.

  - `/(?=(\d|one|two|three|four|five|six|seven|eight|nine))/` - This is the
    regex pattern used for scanning.

  The regex pattern `(?=(\d|one|two|three|four|five|six|seven|eight|nine))`
  employs a positive lookahead `(?=...)` to match any position in the text where
  the following conditions are true without consuming any characters:

  - `\d` matches any digit (0-9).
  - `one|two|three|four|five|six|seven|eight|nine` - This matches any one of the
    spelled-out words for the digits one through nine.

  Since it uses a lookahead, the regex engine checks for the existence of any of
  the provided patterns right at the current position, and if a match is found,
  the scan function will return the matched text (a digit or a spelled-out
  number) without moving the matching position forward. This means that the next
  scan will start immediately after the beginning of the previous match,
  allowing for overlapping matches. The scan function will continue to search
  through the entire string, `line` in this snippet, and return all such matches
  as a list of lists. Each sublist contains one match from the capture group (in
  this case, the captured digit or word).

  Here is a concise explanation of the `Regex.scan` use:

  ```elixir
  matches = Regex.scan(~r/(?=(\d|one|two|three|four|five|six|seven|eight|nine))/, line)
  ```

  - `matches` - Will contain a list of lists, where each sublist contains a
    string of either a single digit or a spelled-out number from the input
    `line` where overlapping matches are allowed.
  """
  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Stream.map(&first_and_last_digit/1)
    |> Stream.map(&concatenate/1)
    |> Enum.sum()
  end

  defp first_and_last_digit(line) do
    digit_only_line = line |> String.graphemes() |> Enum.filter(&process_char/1)
    [first | _] = digit_only_line
    [last | _] = digit_only_line |> Enum.reverse()
    {first, last}
  end

  defp concatenate({first, last}) do
    String.to_integer("#{first}#{last}")
  end

  defp process_char(char) do
    String.match?(char, ~r/[0-9]/)
  end

  def part2(input) do
    input
    |> String.split("\n", trim: true)
    |> Stream.map(&convert_letter_to_digits/1)
    |> Stream.map(&first_and_last_digit/1)
    |> Stream.map(&concatenate/1)
    |> Enum.sum()
  end

  defp convert_letter_to_digits(line) do
    Regex.scan(~r/(?=(\d|one|two|three|four|five|six|seven|eight|nine))/, line)
    |> List.flatten()
    |> Enum.map(fn x ->
      cond do
        x in ["one", "1"] -> "1"
        x in ["two", "2"] -> "2"
        x in ["three", "3"] -> "3"
        x in ["four", "4"] -> "4"
        x in ["five", "5"] -> "5"
        x in ["six", "6"] -> "6"
        x in ["seven", "7"] -> "7"
        x in ["eight", "8"] -> "8"
        x in ["nine", "9"] -> "9"
        true -> x
      end
    end)
    |> Enum.join()
  end
end
