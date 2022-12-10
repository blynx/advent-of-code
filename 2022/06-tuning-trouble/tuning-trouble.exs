defmodule Device do
  @input_file "input.txt"
  # packet marker size
  @pms 4
  # message marker size
  @mms 14

  def read_signal() do
    {:ok, input} = File.read(@input_file)
    find_markers(input)
  end

  defp find_markers(input), do: find_start_of_packet(input, 0)

  defp find_start_of_packet(<<a, b, c, d, other_letters::binary>>, counter) do
    case length(Enum.uniq([a, b, c, d])) == @pms do
      true ->
        result = IO.inspect(counter + @pms)
        find_start_of_message(other_letters, result)

      _ ->
        find_start_of_packet(<<b, c, d, other_letters::binary>>, counter + 1)
    end
  end

  defp find_start_of_message(<<first, etc::binary-size(@mms - 1), rest::binary>>, counter) do
    case length(Enum.uniq(:binary.bin_to_list(<<first>> <> etc))) == @mms do
      true -> IO.puts(counter + @mms)
      _ -> find_start_of_message(etc <> rest, counter + 1)
    end
  end
end

Device.read_signal()
