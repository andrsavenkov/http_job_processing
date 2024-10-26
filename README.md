# HttpJobProcessing

To start service:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

To test the service you can have two options:
1. through a bash terminal
- run `iex -S mix phx.server` to start service inside IEx
- create a variable tasks:
```elixir
tasks = [
  %{"command" => "touch /tmp/file1", "name" => "task-1"},
  %{"command" => "cat /tmp/file1", "name" => "task-2", "requires" => ["task-3"]},
  %{
    "command" => "echo 'Hello World!' > /tmp/file1",
    "name" => "task-3",
    "requires" => ["task-1"]
  },
  %{
    "command" => "rm /tmp/file1",
    "name" => "task-4",
    "requires" => ["task-2", "task-3"]
  }
]
```
- run function `HttpJobProcessing.Tasks.add_tasks(tasks)` to add tasks to the state
- run function `HttpJobProcessing.Tasks.bash_script()` to get bash script that will execute all tasks

2. through a HTTP request
- run `iex -S mix phx.server` to start service inside IEx
- run `curl -X POST -H "Content-Type: application/json" -d '{"tasks": [{"command": "touch /tmp/file1", "name": "task-1"}, {"command": "cat /tmp/file1", "name": "task-2", "requires": ["task-3"]}, {"command": "echo 'Hello World!' > /tmp/file1", "name": "task-3", "requires": ["task-1"]}, {"command": "rm /tmp/file1", "name": "task-4", "requires": ["task-2", "task-3"]}]}' http://localhost:4000/api/task`
- run `curl -X GET http://localhost:4000/api/bash_script`