defmodule SupplyStacks do
  @input_file "input.txt"

  def start() do
    {:ok, input} = File.read(@input_file)
    [stacks_picture, instructions_blob] = String.split(input, "\n\n")
    [raw_aisles | raw_stacks] = stacks_picture |> String.split("\n") |> :lists.reverse()

    instrunction_list = String.split(instructions_blob, "\n")
    stack_map = fill_stack_map(new_stack_map(raw_aisles), raw_stacks)

    process(stack_map, instrunction_list)
  end

  # do stuff

  defp process(stack_map, [instruction | next_instructions]) when instruction != "" do
    [num, from, to] = Regex.scan(~r/\d+/, instruction)
      |> Enum.map(fn [n] -> String.to_integer(n) end)

    stack_map = move_boxes_9001(stack_map, num, from, to)

    process(stack_map, next_instructions)
  end

  defp process(stack_map, []), do: stack_map
  defp process(stack_map, [_whatever | instructions]), do: process(stack_map, instructions)

  defp move_boxes_9001(stack_map, num, from, to) do
    {boxes_from, rest_from} = Enum.split(stack_map[from], num)
    new_to = boxes_from ++ stack_map[to]
    %{stack_map | from => rest_from, to => new_to}
  end

  # defp move_boxes_9000(stack_map, 0, _from, _to), do: stack_map

  # defp move_boxes_9000(stack_map, num, from, to) do
  #   [box_from | rest_from] = stack_map[from]
  #   new_to = [box_from | stack_map[to]]
  #   move_boxes(%{stack_map | from => rest_from, to => new_to}, num - 1, from, to)
  # end

  # make stuff

  defp new_stack_map(raw_aisles) do
    number_of_aisles = raw_aisles
      |> String.codepoints()
      |> Enum.filter(&(&1 != " "))
      |> :lists.reverse()
      |> hd()
      |> String.to_integer()

    for aisle <- 1..number_of_aisles, into: %{} do
      {aisle, []}
    end
  end

  defp fill_stack_map(stack_map, [row | other_rows]) do
    for aisle <- 1..map_size(stack_map), into: %{} do
      box = String.at(row, (aisle * 4 - 2 - 1))
      case box do
        " " -> {aisle, stack_map[aisle]}
        _ -> {aisle, [box | stack_map[aisle]]}
      end
    end
    |> fill_stack_map(other_rows)
  end

  defp fill_stack_map(stack_map, []), do: stack_map
end

SupplyStacks.start()
|> IO.inspect()
