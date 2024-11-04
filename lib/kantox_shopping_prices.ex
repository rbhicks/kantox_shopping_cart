defmodule KantoxShopping.Prices do


  use GenServer
  
  @moduledoc """
  Default Prices in the following format:

  %{product_code: {name, price, ISO currency code}}

  %{
    gr1: {"Green Tea", 3.11, :gbp},
    sr1: {"Strawberries", 5.00, :gbp},
    cf1: {"Coffee", 11.23, :gbp}
  }
  """

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    {:ok, load_current_prices()}
  end

  def handle_call(:get_current_prices, _from, current_prices) do
    {:reply, current_prices, current_prices}
  end

  defp load_current_prices, do: Application.fetch_env!(:kantox_shopping, :product_information)
  
end
