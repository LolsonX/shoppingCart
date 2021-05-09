require_relative 'shopping_cart/shopping_cart'

include ShoppingCart
@products = [
    Product.new("001", "Red Scarf", 9.25),
    Product.new("002", "Silver cufflinks", 45.00),
    Product.new("003", "Silk Dress", 19.95)
]
@promotion_rules = Discounts.new
@promotion_rules.add_product_count_discount("001", 2, new_value: 8.50)
@promotion_rules.add_total_discount("X-Mas10", 0.10, 60)
co = Checkout.new(@promotion_rules)

co.scan(@products[0])
co.scan(@products[1])
co.scan(@products[2])
puts "Basket: 001, 002, 003"
puts "Total price expected: £66.78, Price calculated: £#{co.total}"

co = Checkout.new(@promotion_rules)
puts
co.scan(@products[0])
co.scan(@products[2])
co.scan(@products[0])
puts "Basket: 001, 003, 001"
puts "Total price expected: £36.95, Price calculated: £#{co.total}"

co = Checkout.new(@promotion_rules)
puts
co.scan(@products[0])
co.scan(@products[1])
co.scan(@products[0])
co.scan(@products[2])
puts "Basket: 001, 002, 001, 003"
puts "Total price expected: £73.76, Price calculated: £#{co.total}"

