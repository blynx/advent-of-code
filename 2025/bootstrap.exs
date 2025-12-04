#!/usr/bin/env elixir

defmodule TemplateProcessor do
  @moduledoc """
  A script to copy a template folder and apply string replacements to folder names,
  file names, and file contents.
  """

  def main(args) do
    case validate_args(args) do
      {:ok, {source_folder, replacements, target_location}} ->
        case validate_paths(source_folder, target_location) do
          :ok ->
            case parse_replacements(replacements) do
              {:ok, replacement_pairs} ->
                process_template(source_folder, replacement_pairs, target_location)
              {:error, message} ->
                IO.puts(message)
                System.halt(1)
            end
          {:error, message} ->
            IO.puts(message)
            System.halt(1)
        end
      {:error, message} ->
        IO.puts(message)
        print_usage()
        System.halt(1)
    end
  end

  defp validate_args(args) do
    if length(args) < 3 do
      {:error, "Error: Incorrect number of arguments"}
    else
      [source_folder, replacements, target_location | _] = args
      {:ok, {source_folder, replacements, target_location}}
    end
  end

  defp validate_paths(source_folder, target_location) do
    cond do
      not File.exists?(source_folder) ->
        {:error, "Error: Source folder '#{source_folder}' does not exist"}
      not File.exists?(target_location) ->
        {:error, "Error: Target location '#{target_location}' does not exist"}
      true ->
        :ok
    end
  end

  defp parse_replacements(replacements_str) do
    pairs =
      replacements_str
      |> String.split(" ")
      |> Enum.filter(&String.contains?(&1, ","))

    if Enum.empty?(pairs) do
      {:error, "Error: No valid replacement pairs found in '#{replacements_str}'"}
    else
      replacement_pairs =
        Enum.map(pairs, fn pair ->
          [from, to] = String.split(pair, ",", parts: 2)
          {from, to}
        end)
      {:ok, replacement_pairs}
    end
  end

  defp process_template(source_folder, replacement_pairs, target_location) do
    # Create new folder name by applying all replacements to source folder name
    new_folder_name =
      Enum.reduce(replacement_pairs, Path.basename(source_folder), fn {from, to}, acc ->
        String.replace(acc, from, to)
      end)

    target_path = Path.join(target_location, new_folder_name)

    # Copy the entire folder structure to target location
    File.cp_r!(source_folder, target_path)

    # Apply all replacements to directory names (bottom-up to avoid path issues)
    Enum.each(replacement_pairs, fn {from_str, to_str} ->
      apply_replacements_to_directories(target_path, from_str, to_str)
    end)

    # Apply all replacements to file names
    Enum.each(replacement_pairs, fn {from_str, to_str} ->
      apply_replacements_to_filenames(target_path, from_str, to_str)
    end)

    # Apply all replacements to file contents
    Enum.each(replacement_pairs, fn {from_str, to_str} ->
      apply_replacements_to_contents(target_path, from_str, to_str)
    end)

    print_success_message(source_folder, target_path, replacement_pairs)
  end

  defp apply_replacements_to_directories(target_path, from_str, to_str) do
    Path.wildcard(Path.join(target_path, "**/*#{from_str}*"))
    |> Enum.filter(&File.dir?/1)
    |> Enum.each(fn dir ->
      new_dir = String.replace(dir, from_str, to_str)
      if dir != new_dir do
        File.rename!(dir, new_dir)
      end
    end)
  end

  defp apply_replacements_to_filenames(target_path, from_str, to_str) do
    Path.wildcard(Path.join(target_path, "**/*#{from_str}*"))
    |> Enum.filter(&File.regular?/1)
    |> Enum.each(fn file ->
      new_file = String.replace(file, from_str, to_str)
      if file != new_file do
        File.rename!(file, new_file)
      end
    end)
  end

  defp apply_replacements_to_contents(target_path, from_str, to_str) do
    Path.wildcard(Path.join(target_path, "**/*"))
    |> Enum.filter(&File.regular?/1)
    |> Enum.each(fn file ->
      try do
        content = File.read!(file)
        updated_content = String.replace(content, from_str, to_str)
        File.write!(file, updated_content)
      rescue
        # Skip binary files or files that can't be read as text
        _ -> :ok
      end
    end)
  end

  defp print_usage do
    IO.puts("Usage: elixir script.exs <source_folder> <replacements> <target_location>")
    IO.puts("Example: elixir script.exs template_folder 'OLD_NAME,NEW_NAME FOO,BAR' .")
    IO.puts("Replacements format: 'FROM1,TO1 FROM2,TO2 FROM3,TO3'")
  end

  defp print_success_message(source_folder, target_path, replacement_pairs) do
    IO.puts("Successfully copied '#{source_folder}' to '#{target_path}' with string replacements")
    Enum.each(replacement_pairs, fn {from, to} ->
      IO.puts("Replaced '#{from}' with '#{to}' in folder names, file names, and file contents")
    end)
  end
end

# Run the main function with command line arguments
System.argv() |> TemplateProcessor.main()
