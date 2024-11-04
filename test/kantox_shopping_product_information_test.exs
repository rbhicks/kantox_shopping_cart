defmodule KantoxShoppingProductInformationTest do
  use ExSpec
  doctest KantoxShopping.ProductInformation

  setup do
    {:ok,
     default_product_information: Application.fetch_env!(:kantox_shopping, :product_information)}
  end

  describe "the kantox shopping prices" do
    context "checking price veracity" do
      it "should return the defaults", %{default_product_information: default_product_information} do
        assert default_product_information ==
                 GenServer.call(
                   KantoxShopping.ProductInformation,
                   :get_current_product_information
                 )
      end
    end
  end
end
