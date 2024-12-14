defmodule AocUtilTest do
  use ExUnit.Case
  import AocUtil

  test "Getter" do
    {get_value, _} = use_state(123)
    assert get_value.() === 123
  end

  test "Setter" do
    {get_value, set_value} = use_state(0)
    set_value.(456)
    assert get_value.() === 456
  end

  test "Updater" do
    {get_value, set_value} = use_state(5)
    set_value.(fn current_value -> current_value * 5 end)
    assert get_value.() === 25
  end
end
