defmodule ElfCamp do
  @inputFile "input.txt"

  def cleanup() do
    {:ok, input} = File.read(@inputFile)

    parsed = input
    |> String.split("\n")
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(&(parseAssignmentPair(&1)))

    sumUp(parsed)
  end

  defp parseAssignmentPair(line) do
    line
    |> String.split(["-", ","])
    |> Enum.map(&String.to_integer(&1))
  end

  defp sumUp(list), do: sumUp(list, {0, 0})

  defp sumUp([[s1, e1, s2, e2] | tail], {overlapping, fullyOverlapping})
  when (s1 <= s2 and e1 >= e2) or (s2 <= s1 and e2 >= e1) do
    sumUp(tail, {overlapping + 1, fullyOverlapping + 1})
  end

  defp sumUp([[s1, e1, s2, e2] | tail], {overlapping, fullyOverlapping})
  when (e1 >= s2 and e1 <= e2) or (e2 >= s1 and e2 <= e1) do
    sumUp(tail, {overlapping,  fullyOverlapping + 1})
  end

  defp sumUp([_head | tail], sum), do: sumUp(tail, sum)

  defp sumUp([], r), do: r
end

ElfCamp.cleanup() |> IO.inspect()
