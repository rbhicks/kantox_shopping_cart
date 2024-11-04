defmodule KantoxShoppingCheckoutTest do
  use ExSpec
  doctest KantoxShopping.Checkout

  # setup do

  # end

  describe "in the kantox checkout operations" do
    context "the basic 'add item to basket' operation" do
      it "should give a list of item codes with the new code added to the end of the list" do
        GenServer.cast(KantoxShopping.Checkout, :clear_item_codes)
        GenServer.cast(KantoxShopping.Checkout, {:add_item_code, :gr1})
        GenServer.cast(KantoxShopping.Checkout, {:add_item_code, :sr1})
        assert [:gr1, :sr1] == GenServer.call(KantoxShopping.Checkout, :get_item_codes)
      end
    end

    context "the offers" do
      it "Basket: GR1,SR1,GR1,GR1,CF1 should be 22.45" do
        GenServer.cast(KantoxShopping.Checkout, :clear_item_codes)
        GenServer.cast(KantoxShopping.Checkout, {:add_item_code, :gr1})
        GenServer.cast(KantoxShopping.Checkout, {:add_item_code, :sr1})
        GenServer.cast(KantoxShopping.Checkout, {:add_item_code, :gr1})
        GenServer.cast(KantoxShopping.Checkout, {:add_item_code, :gr1})
        GenServer.cast(KantoxShopping.Checkout, {:add_item_code, :cf1})

        assert 22.45 == GenServer.call(KantoxShopping.Checkout, :get_total)
      end

      it "Basket: GR1,GR1 should be 3.11" do
        GenServer.cast(KantoxShopping.Checkout, :clear_item_codes)
        GenServer.cast(KantoxShopping.Checkout, {:add_item_code, :gr1})
        GenServer.cast(KantoxShopping.Checkout, {:add_item_code, :gr1})

        assert 3.11 == GenServer.call(KantoxShopping.Checkout, :get_total)
      end

      it "Basket: SR1,SR1,GR1,SR1 should be 16.61" do
        GenServer.cast(KantoxShopping.Checkout, :clear_item_codes)
        GenServer.cast(KantoxShopping.Checkout, {:add_item_code, :sr1})
        GenServer.cast(KantoxShopping.Checkout, {:add_item_code, :sr1})
        GenServer.cast(KantoxShopping.Checkout, {:add_item_code, :gr1})
        GenServer.cast(KantoxShopping.Checkout, {:add_item_code, :sr1})

        assert 16.61 == GenServer.call(KantoxShopping.Checkout, :get_total)
      end

      # this rule has been changed as there appears to be an error in
      # the test spec (which says the total should be 30.57. the subtotals
      # work out like this:
      # gr1 -> 3.11
      # sr1 -> 5.0
      # cf1 -> 22.24 (rounded up at two decimal places)
      it "Basket: GR1,CF1,SR1,CF1,CF1 should be 30.35" do
        GenServer.cast(KantoxShopping.Checkout, :clear_item_codes)
        GenServer.cast(KantoxShopping.Checkout, {:add_item_code, :gr1})
        GenServer.cast(KantoxShopping.Checkout, {:add_item_code, :cf1})
        GenServer.cast(KantoxShopping.Checkout, {:add_item_code, :sr1})
        GenServer.cast(KantoxShopping.Checkout, {:add_item_code, :cf1})
        GenServer.cast(KantoxShopping.Checkout, {:add_item_code, :cf1})

        assert 30.35 == GenServer.call(KantoxShopping.Checkout, :get_total)
      end
    end
  end
end
