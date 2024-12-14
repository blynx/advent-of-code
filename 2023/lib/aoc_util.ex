defmodule AocUtil do
  @moduledoc """
  Just some utilities.
  """

  @doc """
  lol?
  """
  def use_state(initial_value) do
    {:ok, pid} = Agent.start_link(fn -> initial_value end)
    getter = fn -> Agent.get(pid, & &1) end

    setter = fn
      update_fn when is_function(update_fn) -> Agent.update(pid, update_fn)
      new_state -> Agent.update(pid, fn _state -> new_state end)
    end

    {getter, setter}
  end
end
