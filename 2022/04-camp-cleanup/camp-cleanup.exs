defmodule ElfCamp do
  @input_file "input.txt"

  def cleanup() do
    {:ok, input} = File.read(@input_file)

    parsed =
      input
      |> String.split("\n")
      |> Enum.filter(&(&1 != ""))
      |> Enum.map(&parse_assignment_pair(&1))

    sum_up(parsed)
  end

  defp parse_assignment_pair(line) do
    line
    |> String.split(["-", ","])
    |> Enum.map(&String.to_integer(&1))
  end

  defp sum_up(list), do: sum_up(list, {0, 0})

  defp sum_up([[s1, e1, s2, e2] | tail], {overlapping, fully_overlapping})
       when (s1 <= s2 and e1 >= e2) or (s2 <= s1 and e2 >= e1) do
    sum_up(tail, {overlapping + 1, fully_overlapping + 1})
  end

  defp sum_up([[s1, e1, s2, e2] | tail], {overlapping, fully_overlapping})
       when (e1 >= s2 and e1 <= e2) or (e2 >= s1 and e2 <= e1) do
    sum_up(tail, {overlapping, fully_overlapping + 1})
  end

  defp sum_up([_head | tail], sum), do: sum_up(tail, sum)

  defp sum_up([], r), do: r
end

ElfCamp.cleanup() |> IO.inspect()
