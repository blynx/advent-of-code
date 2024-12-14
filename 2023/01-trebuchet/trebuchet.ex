defmodule Trebuchet do
  def calibrate(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.replace(&1, ~r/\D/, ""))
    |> Enum.map(fn line ->
      first = String.at(line, 0)
      last = String.at(line, -1)
      String.to_integer(first <> last)
    end)
    |> Enum.sum()
  end

  def calibrate_part2(input) do
    input
    |> String.trim()
    |> replace_numbers()
    |> String.split("\n")
    |> Enum.map(&String.replace(&1, ~r/\D/, ""))
    |> Enum.map(fn line ->
      first = String.at(line, 0)
      last = String.at(line, -1)
      String.to_integer(first <> last)
    end)
    |> Enum.sum()
  end

  defp replace_numbers(string) do
    string
    |> String.replace(
      ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"],
      fn match ->
        case match do
          "one" -> "1"
          "two" -> "2"
          "three" -> "3"
          "four" -> "4"
          "five" -> "5"
          "six" -> "6"
          "seven" -> "7"
          "eight" -> "8"
          "nine" -> "9"
        end
      end
    )
  end
end
