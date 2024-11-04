defmodule KantoxShopping.Checkout do


  use GenServer
  
  @moduledoc """
  """

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    {:ok, clear_item_codes()}
  end

  def handle_cast({:add_item_code, item_code}, item_codes) do
    {:noreply, item_codes ++ [item_code]}
  end

  def handle_cast(:clear_item_codes, item_codes) do
    {:noreply, clear_item_codes(item_codes)}
  end

  def handle_call(:get_item_codes, _from, item_codes) do
    {:reply, item_codes, item_codes}
  end

  def handle_call(:get_total, _from, item_codes) do
    {:reply, get_total(item_codes), item_codes}
  end

  defp clear_item_codes(), do: []
  # just in case in the future clearing has
  # more complex logic. right now, it just
  # calls the above.
  defp clear_item_codes(_item_codes), do: clear_item_codes()
  
  defp get_total(item_codes) do
    product_information = GenServer.call(KantoxShopping.ProductInformation, :get_current_product_information)
    
    item_codes
    |> Enum.frequencies()
    |> Enum.reduce(0, fn item_code_frequency, total ->
      total + get_subtotal(item_code_frequency, product_information)
    end)
  end

  defp get_subtotal({:gr1, item_code_count}, product_information) when (item_code_count / 2) > 1 do

    {discounted_pairs, base_price} = get_discounted_pairs_and_base_price(item_code_count, product_information)
    discounted_pairs = discounted_pairs |> trunc

    # since this function head requires that (item_code_count / 2) > 1
    # it means we have an odd number. discounted_pairs counts each pair
    # as one item and then we add one more because it's an add number;
    # i.e., as we have an odd number, once when account for all the pairs,
    # an even number, we need to add one more: 2n + 1 is an odd number.
    (discounted_pairs * base_price) + base_price
  end

  defp get_subtotal({:gr1, item_code_count}, product_information) when rem(item_code_count, 2) == 0 do
    {discounted_pairs, base_price} = get_discounted_pairs_and_base_price(item_code_count, product_information)

    discounted_pairs * base_price
  end

  defp get_subtotal({:sr1, item_code_count}, product_information) when item_code_count >= 3 do
    {_, _, discounted_price, _} = Map.get(product_information, :sr1)
    
    discounted_price * item_code_count
  end
  
  defp get_subtotal({item_code, 1}, product_information) do
    {_, base_price, _, _} = Map.get(product_information, item_code)
    base_price
  end

  defp get_subtotal({_item_code, _item_code_count}, _product_information), do: 0

  defp get_discounted_pairs_and_base_price(item_code_count, product_information) do
    discounted_pairs = item_code_count / 2
    {_, base_price, _, _} = Map.get(product_information, :gr1)

    {discounted_pairs, base_price}
  end
end
