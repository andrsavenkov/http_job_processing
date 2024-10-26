defmodule HttpJobProcessingWeb.TaskController do
  use HttpJobProcessingWeb, :controller
  @moduledoc false

  def create(conn, %{"tasks" => tasks}) do
    result = HttpJobProcessing.Tasks.add_tasks(tasks)
    json(conn, %{"task" => result})
  end

  def bash_script(conn, _params) do
    bash_script = HttpJobProcessing.Tasks.bash_script()
    json(conn, %{"bash_script" => bash_script})
  end

end
