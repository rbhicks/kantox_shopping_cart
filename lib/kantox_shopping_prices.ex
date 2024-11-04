defmodule KantoxShopping.Prices do


  use GenServer
  
  @moduledoc """
  Default Prices in the following format:

  {product_code, name, price, ISO currency code}

  {GR1, Green Tea, 3.11, GBP}
  {SR1, Strawberries, 5.00, GBP}
  {CF1, Coffee, 11.23, GBP}
  """

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end


  def init(args) do
    {:ok, args}
  end
  
  
end
