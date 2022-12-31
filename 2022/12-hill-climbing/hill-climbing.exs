defmodule Karte do
  defstruct data: %{}, w: 0, h: 0

  def new(input) do
    lines = String.split(input, "\n", trim: true)

    indexed_data =
      lines
      |> Enum.join("")
      |> String.to_charlist()
      |> Enum.with_index()

    data = for {value, index} <- indexed_data, into: %{}, do: {index, value}
    width = String.length(hd(lines))
    height = length(lines)

    %Karte{data: data, w: width, h: height}
  end

  def new(w, h, filler \\ 0) do
    data = for index <- 1..(w * h), into: %{}, do: {index, filler}
    %Karte{data: data, w: w, h: h}
  end

  def map(map, function) do
    data = for i <- 0..(map.w * map.h - 1), into: %{}, do: {i, function.(Map.get(map.data, i))}
    %Karte{map | data: data}
  end

  def to_coords(map, index), do: {rem(index, map.w), div(index, map.w)}
  def to_index(map, {x, y}), do: x + map.w * y

  def in_map?(map, {x, y}), do: not (x < 0 or y < 0 or x > map.w - 1 or y > map.h - 1)

  def where(map, thing) do
    {index, _} = Enum.find(map.data, fn {_, v} -> thing == v end)
    Karte.to_coords(map, index)
  end

  def get(map, pos) do
    case in_map?(map, pos) do
      true -> map.data[to_index(map, pos)]
      false -> :not_in_map
    end
  end

  def set!(map, pos, value) do
    {x, y} = pos

    case in_map?(map, pos) do
      true ->
        %Karte{map | data: %{map.data | to_index(map, pos) => value}}

      false ->
        raise(ArgumentError, message: "#{inspect({x, y})} outside of map #{map.w} by #{map.h}")
    end
  end

  def render(map) do
    %Karte{data: data, w: w, h: h} = map

    for y <- 0..(h - 1), into: [] do
      for x <- 0..(w - 1), into: [] do
        Map.get(data, Karte.to_index(map, {x, y}))
      end
    end
    |> IO.inspect()
  end
end

defmodule Navigator do
  def letsgo(input) do
    raw_map = Karte.new(input)
    start_pos = Karte.where(raw_map, ?S)
    summit_pos = Karte.where(raw_map, ?E)

    start_height = 0
    summit_height = ?z - ?a

    height_map =
      raw_map
      |> Karte.map(fn v ->
        case v do
          ?S -> start_height
          ?E -> summit_height
          _ -> v - ?a
        end
      end)

    initial_steps = 0

    IO.puts("To the summit! Fewest steps from start position:")

    find_summit_steps_map = Karte.map(height_map, fn _ -> nil end)
    {:ok, find_summit_steps_tracker} = Agent.start_link(fn -> find_summit_steps_map end)
    move(:upwards, height_map, find_summit_steps_tracker, start_pos, initial_steps, start_height)

    find_summit_final_steps_map = Agent.get(find_summit_steps_tracker, & &1)
    Karte.get(find_summit_final_steps_map, summit_pos) |> IO.inspect()

    IO.puts("Where to start? Fewest steps from lowest height:")

    find_entry_steps_map = Karte.map(height_map, fn _ -> nil end)
    {:ok, find_entry_steps_tracker} = Agent.start_link(fn -> find_entry_steps_map end)

    move(
      :downwards,
      height_map,
      find_entry_steps_tracker,
      summit_pos,
      initial_steps,
      summit_height
    )

    find_entry_final_steps_map = Agent.get(find_entry_steps_tracker, & &1)

    height_map.data
    |> Enum.filter(fn {_, h} -> h == 0 end)
    |> Enum.map(fn {index, _} -> {index, find_entry_final_steps_map.data[index]} end)
    |> Enum.filter(fn {_, steps} -> steps != nil end)
    |> Enum.sort(fn {_, steps_a}, {_, steps_b} -> steps_a <= steps_b end)
    |> hd()
    |> elem(1)
    |> IO.inspect()
  end

  defp can_move?(:upwards, from_height, to_height, last_steps, here_steps) do
    to_height - from_height <= 1 and (last_steps < here_steps or here_steps == nil)
  end

  defp can_move?(:downwards, from_height, to_height, last_steps, here_steps) do
    from_height - to_height <= 1 and (last_steps < here_steps or here_steps == nil)
  end

  defp move(vdirection, height_map, steps_tracker, pos, last_steps, from_height) do
    {x, y} = pos
    here_height = Karte.get(height_map, pos)
    here_steps = Agent.get(steps_tracker, &Karte.get(&1, pos))

    cond do
      here_height == :not_in_map ->
        nil

      true ->
        case can_move?(vdirection, from_height, here_height, last_steps, here_steps) do
          true ->
            Agent.update(steps_tracker, &Karte.set!(&1, pos, last_steps))
            move(vdirection, height_map, steps_tracker, {x, y - 1}, last_steps + 1, here_height)
            move(vdirection, height_map, steps_tracker, {x + 1, y}, last_steps + 1, here_height)
            move(vdirection, height_map, steps_tracker, {x, y + 1}, last_steps + 1, here_height)
            move(vdirection, height_map, steps_tracker, {x - 1, y}, last_steps + 1, here_height)

          _ ->
            nil
        end
    end
  end
end

File.read!("input.txt")
|> Navigator.letsgo()
