defmodule Directory do
  defstruct files: [], dirs: []

  def add(directory, ls_line) do
    if String.starts_with?(ls_line, "dir") do
      # add directory
    else
      # add file
    end
  end

  def calculate_size() do
    # calculate size all the way
  end
end

defmodule Disk do
  defstruct dirs:
  @file "input.txt"

  def go() do
    {:ok, input} = File.read(@file)
    input
    |> String.split()
    |> traverse()
  end

  defp traverse([line | rest]) do
    case line do
       ->

    end
  end
end
