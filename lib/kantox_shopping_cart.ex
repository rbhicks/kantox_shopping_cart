defmodule KantoxShoppingCart do
  @moduledoc """
  Documentation for `KantoxShoppingCart`.
  """

  use Application
  
  def start(_type, _args) do
    children = []
    Supervisor.start_link(children, strategy: :one_for_one)

    "==============================" |> IO.puts
    "KantoxShoppingCart starting..." |> IO.puts
    "==============================" |> IO.puts

    {:ok, self()}
  end
end
