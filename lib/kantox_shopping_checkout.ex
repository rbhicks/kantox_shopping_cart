defmodule KantoxShopping.Checkout do


  use GenServer
  
  @moduledoc """
  """

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    {:ok, []}
  end
end
