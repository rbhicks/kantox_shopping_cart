# KantoxShoppingCart

## Installation

Standard procedure:

- clone repo
- cd to repo directory
- mix deps.install

## Execution

Given the description specifically gives test cases, this backed is run, and tested, by just running `mix test`. All tests passing is indicative that the functionality in correct.

## Architectural Description

Given that there is no DB requirement, and no mention of Phoenix, I made this as a standard OTP Application using two GenServers to maintain state:

### Application

Starts the GenServers and puts them it its supervision tree. The default values, so they can be easily changed, are stored in config/config.exs (the format of the fields is described in KantoxShopping.ProductInformation).

### KantoxShopping.ProductInformation

Maintains the ProductInformation. In future, it would probably be expanded to allow for changing the ProductInformation at runtime. Currently, it's only loaded on start and then can be retrieved. Also, as the prices were quoted in GBP, the calculations are made and the total returned simply as floats. However, the currency code is maintained so it could in theory be displayed, converted, etc.

### KantoxShopping.Checkout

Maintains the shopping cart state and calculates the totals via the discount rules. The biggest issue that would need to be addressed in future would be to add support for multiple shopping carts. Essestially, the same logic, but with the state being a map with individual keys.
It's possible that certain rules could be made generic, for instance, the "two for one" rule is currently specific to green tea, but there may be a future product that would use the same logic. This could be easily solved by breaking the logic out into a utility function and using multiple function heads, based on the item code, and calling the utility function.

## Testing Regime

I opted to used ex_spec as I've found it makes tests more clear. There is a problem, more of a compromise really, in that these tests are all "happy path" tests. The reason for this is that the failure paths for something this simple seemed highly "synthetic"; i.e., a test just to do a test, but not really testing anything. The only possible exception would be to test what happens when an incorrect item code is added to the cart. However, this test is dependent on the error handling theory in place. I tend to prefer the "fail and restart" philosophy of Erlang and Elixir. In this case, I think this would be more effective than just reporting an unresolvable error or transparently not adding an item.

## Notes

My primary note is that there seems to be an error in the fourth test case:

Basket: GR1,CF1,SR1,CF1,CF1
Total price expected: £30.57

This total seems to be in error.

The subtotals work out like this:
gr1 -> 3.11
sr1 -> 5.0
cf1 -> 22.24 (11.23 * 3 * 0.66 rounded up at two decimal places)

As such, this comes out to a total of 30.35.

I suspect only two possibilites, I ran into a floating point calcuation error that is extremely obscure -- doubtful given that I checked the man on multiple calculators), or that the error is a deliberate part of the test to see how I'd react to it :-)
