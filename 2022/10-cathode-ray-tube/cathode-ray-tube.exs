defmodule Tube do
  defstruct cycles: 0, x: 1, signal_strength_sum: 0, screen: []
  @input "input.txt"
  @op_cycles %{:noop => 1, :addx => 2}

  def process() do
    instructions =
      File.read!(@input)
      |> String.split("\n")

    process(%Tube{}, instructions)
  end

  def render(state) when is_struct(state) do
    state.screen
    |> :lists.reverse()
    |> Enum.join()
    |> render()
  end

  def render(<<line::binary-size(40), tl::binary>>) do
    IO.puts(line)
    render(tl)
  end

  def render(_), do: IO.puts("fin.")

  defp process(state, instructions)
  defp process(state, []), do: state
  defp process(state, [""]), do: state

  defp process(state, [instruction | other_instructions]) do
    case String.split(instruction, " ") do
      ["addx", arg] -> execute(state, &addx/2, arg, @op_cycles.addx)
      ["noop"] -> execute(state, &noop/2, nil, @op_cycles.noop)
      _ -> state
    end
    |> process(other_instructions)
  end

  # the executioner, executes after final operation cycle

  defp execute(state, operation, arg, 0) do
    %Tube{x: new_x} = operation.(state, arg)
    %Tube{state | x: new_x}
  end

  # the cycler, cycling on every cycle

  defp execute(state, operation, arg, op_cycles) do
    # order is important.

    state = paint(state)

    state = %Tube{state | cycles: state.cycles + 1}

    current_signal_strength =
      case rem(state.cycles + 20, 40) do
        0 -> state.x * state.cycles
        _ -> 0
      end

    state = %Tube{
      state
      | signal_strength_sum: state.signal_strength_sum + current_signal_strength
    }

    execute(state, operation, arg, op_cycles - 1)
  end

  defp paint(state) do
    %Tube{cycles: cycles, x: x, screen: screen} = state
    pos = rem(cycles, 40)

    pixel =
      case pos >= x - 1 && pos <= x + 1 do
        true -> "#"
        false -> "."
      end

    %Tube{state | screen: [pixel | screen]}
  end

  # the operations

  defp noop(state, _noarg_for_noop) do
    state
  end

  defp addx(state, arg) do
    num = String.to_integer(arg)
    %Tube{state | x: state.x + num}
  end
end

Tube.process()
|> IO.inspect()
|> Tube.render()
