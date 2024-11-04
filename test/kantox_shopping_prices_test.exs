defmodule KantoxShoppingPricesTest do
  use ExSpec
  doctest KantoxShopping.Prices

  setup do
    {:ok, default_prices: Application.fetch_env!(:kantox_shopping, :product_information)}
  end
  
  describe "the kantox shopping prices" do
    context "checking price veracity" do
      it "should return the defaults", %{default_prices: default_prices} do
        assert default_prices == GenServer.call(KantoxShopping.Prices, :get_current_prices)
      end
    end
  end
end
