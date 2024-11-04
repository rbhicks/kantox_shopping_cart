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

      # it "should fail if the item code is incorrect" do
      #   assert false
      # end
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

      it "Basket: Basket: GR1,GR1 should be 3.11" do
        GenServer.cast(KantoxShopping.Checkout, :clear_item_codes)
        GenServer.cast(KantoxShopping.Checkout, {:add_item_code, :gr1})
        GenServer.cast(KantoxShopping.Checkout, {:add_item_code, :gr1})

        assert 3.11 == GenServer.call(KantoxShopping.Checkout, :get_total)
      end
    end
  end
end
