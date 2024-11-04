defmodule KantoxShopping.Application do
  @moduledoc """
  Documentation for `KantoxShopping`.
  """

  use Application
  
  def start(_type, _args) do
    children = [KantoxShopping.Prices]
    
    Supervisor.start_link(children, strategy: :one_for_one)

    "==============================" |> IO.puts
    "KantoxShopping starting..." |> IO.puts
    "==============================" |> IO.puts

    {:ok, self()}
  end
end
