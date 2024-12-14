defmodule TrebuchetTest do
  use ExUnit.Case

  test "Example Part 1" do
    input = """
    1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet
    """

    result = Trebuchet.calibrate(input)
    assert result == 142
  end

  test "Part 1" do
    input = File.read!(__DIR__ <> "/calibration_document.aoc")
    result = Trebuchet.calibrate(input)
    assert result == 54081
  end

  test "Example Part 2" do
    input = """
    two1nine
    eightwothree
    abcone2threexyz
    xtwone3four
    4nineeightseven2
    zoneight234
    7pqrstsixteen
    """

    result = Trebuchet.calibrate_part2(input)
    assert result == 281
  end

  @tag :skip
  test "Part 2" do
    input = File.read!(__DIR__ <> "/calibration_document.aoc")
    result = Trebuchet.calibrate(input)
    assert result == 54081
  end
end
