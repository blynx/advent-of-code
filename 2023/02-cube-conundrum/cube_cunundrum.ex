defmodule CubeConundrum do
  def sum_of_possible_games(input, bag) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&settle_game(&1, bag))
    |> Enum.sum()
  end

  def settle_game(game_string, bag) do
    [game_name, game] = String.split(game_string, ": ")
    [game_id_string] = Regex.run(~r/\d+/, game_name)
    game_id = String.to_integer(game_id_string)

    game_is_possible =
      String.split(game, ["; ", ", "])
      |> Enum.all?(&reveal_possible?/2, bag)

    if game_is_possible, do: game_id, else: 0
  end

  defp reveal_possible?(reveal_string, bag) do

  end
end
