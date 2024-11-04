defmodule KantoxShopping.Checkout do
  use GenServer

  @moduledoc """
  Maintains the shopping cart state and calculates the totals via the discount rules. The biggest issue that would need to be addressed in future would be to add support for multiple shopping carts. Essestially, the same logic, but with the state being a map with individual keys.
  It's possible that certain rules could be made generic, for instance, the "two for one" rule is currently specific to green tea, but there may be a future product that would use the same logic. This could be easily solved by breaking the logic out into a utility function and using multiple function heads, based on the item code, and calling the utility function.
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
    product_information =
      GenServer.call(KantoxShopping.ProductInformation, :get_current_product_information)

    item_codes
    |> Enum.frequencies()
    |> Enum.reduce(0, fn item_code_frequency, total ->
      total + get_subtotal(item_code_frequency, product_information)
    end)
    |> Float.round(2)
  end

  # green tea discount rule for odd numbers
  defp get_subtotal({:gr1, item_code_count}, product_information) when item_code_count / 2 > 1 do
    {discounted_pairs, base_price} =
      get_discounted_pairs_and_base_price_for_green_tea(item_code_count, product_information)

    discounted_pairs = discounted_pairs |> trunc

    # since this function head requires that (item_code_count / 2) > 1
    # it means we have an odd number. discounted_pairs counts each pair
    # as one item and then we add one more because it's an add number;
    # i.e., as we have an odd number, once when account for all the pairs,
    # an even number, we need to add one more: 2n + 1 is an odd number.
    discounted_pairs * base_price + base_price
  end

  # green tea discount rule for even numbers
  defp get_subtotal({:gr1, item_code_count}, product_information)
       when rem(item_code_count, 2) == 0 do
    {discounted_pairs, base_price} =
      get_discounted_pairs_and_base_price_for_green_tea(item_code_count, product_information)

    discounted_pairs * base_price
  end

  # strawberry discount rule
  defp get_subtotal({:sr1, item_code_count}, product_information) when item_code_count >= 3 do
    {_, _, discounted_price, _, _} = Map.get(product_information, :sr1)

    discounted_price * item_code_count
  end

  # coffee discount rule
  defp get_subtotal({:cf1, item_code_count}, product_information) when item_code_count >= 3 do
    {_, base_price, _, discount_multiplier, _} = Map.get(product_information, :cf1)

    base_price * item_code_count * discount_multiplier
  end

  # non-discounted subtotal rule for everything
  defp get_subtotal({item_code, item_code_count}, product_information) do
    {_, base_price, _, _, _} = Map.get(product_information, item_code)
    base_price * item_code_count
  end

  # utility function to avoid code duplication
  defp get_discounted_pairs_and_base_price_for_green_tea(item_code_count, product_information) do
    discounted_pairs = item_code_count / 2
    {_, base_price, _, _, _} = Map.get(product_information, :gr1)

    {discounted_pairs, base_price}
  end
end
