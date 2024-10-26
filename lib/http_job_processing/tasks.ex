defmodule HttpJobProcessing.Tasks do
  @moduledoc false

  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def add_tasks(params) do
    GenServer.call(__MODULE__, {:add_tasks, params})
  end

  def bash_script() do
    GenServer.call(__MODULE__, :bash_script)
  end

  def init(_opts) do
    {:ok, %{bash_sorted_tasks: []}}
  end

  def handle_call({:add_tasks, tasks}, _from, state) do
    bash_sorted_tasks = sort_tasks(tasks)
    new_state = %{state | bash_sorted_tasks: bash_sorted_tasks}

    {:reply, bash_sorted_tasks, new_state}
  end

  def handle_call(:bash_script, _from, %{bash_sorted_tasks: bash_sorted_tasks} = state) do
    bash_script =
      bash_sorted_tasks
      |> Enum.map(&Map.get(&1, "command"))
      |> List.insert_at(0, "#!/usr/bin/env bash")
      |> Enum.join("\n")
    {:reply, bash_script, state}
  end

  def sort_tasks(tasks, acc \\ [])
  def sort_tasks([], acc), do: Enum.reverse(acc)
  def sort_tasks(tasks, acc) do
    # we assume that the tasks in the acc are stored in the correct order,
    # so to get the next task from the request,
    # we get the sorted names of the tasks that are already in the acc
    requires_search_key = Enum.map(acc, &Map.get(&1, "name"))
    # then we try to find the same task that has in requires the same names as tasks name that we have in the acc
    task = Enum.find(tasks, fn task -> Map.get(task, "requires", []) -- requires_search_key == [] end)
    # if we cannot find nothing we left acc as is and stop the recursion
    {continue_tasks, acc} =
      if !is_nil(task) do
        {tasks -- [task], [%{"name" => task["name"], "command" => task["command"]} | acc]}
      else
        {[], acc}
      end

    sort_tasks(continue_tasks, acc)
  end
end
