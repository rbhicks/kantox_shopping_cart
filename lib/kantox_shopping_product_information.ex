defmodule KantoxShopping.ProductInformation do
  use GenServer

  @moduledoc """
  Default Prices in the following format:

  %{product_code: {name, price, discounted price (nil if n/a), discount multiplier (nil if n/a), ISO currency code}}

  %{
    gr1: {"Green Tea", 3.11, nil, nil, :gbp},
    sr1: {"Strawberries", 5.00, 4.50, nil, :gbp},
    cf1: {"Coffee", 11.23, nil, 0.66, :gbp}
  }

  N.B.: the prices were quoted in GBP, the calculations are made and the total
  returned simply as floats. However, the currency code is maintained so it could
  in theory be displayed, converted, etc.
  """

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    {:ok, load_current_prices()}
  end

  def handle_call(:get_current_product_information, _from, current_product_information) do
    {:reply, current_product_information, current_product_information}
  end

  defp load_current_prices, do: Application.fetch_env!(:kantox_shopping, :product_information)
end
