require 'rspec'
require_relative '../shopping_cart/shopping_cart'
describe 'ShoppingCart' do
  before do
    @promotion_rules = ShoppingCart::Discounts.new
    @products = [
        ShoppingCart::Product.new("001", "Red Scarf", 9.25),
        ShoppingCart::Product.new("002", "Silver cufflinks", 45.00),
        ShoppingCart::Product.new("003", "Silk Dress", 19.95)
    ]
  end
  it 'calculates correct price for no discounts' do
    co = ShoppingCart::Checkout.new(@promotion_rules)
    co.scan @products[0]
    co.scan @products[1]
    co.scan @products[2]
    expect(co.total).to be_eql(74.20)
  end

  it 'calculates correct price for multiple items discount' do
    @promotion_rules.add_product_count_discount("001", 2, new_value: 8.50)
    co = ShoppingCart::Checkout.new(@promotion_rules)
    co.scan @products[0]
    co.scan @products[1]
    co.scan @products[0]
    co.scan @products[2]
    expect(co.total).to be_eql(81.95)
  end

  it 'calculates correct price for sum above some value' do
    @promotion_rules.add_total_discount("X-Mas10", 0.10, 60)
    co = ShoppingCart::Checkout.new(@promotion_rules)
    co.scan @products[0]
    co.scan @products[1]
    co.scan @products[0]
    co.scan @products[2]
    expect(co.total).to be_eql(75.11)
  end

  it 'calculates correct price for mixed rules' do
    @promotion_rules.add_total_discount("X-Mas10", 0.10, 60)
    @promotion_rules.add_product_count_discount("001", 2, new_value: 8.50)
    co = ShoppingCart::Checkout.new(@promotion_rules)
    co.scan @products[0]
    co.scan @products[1]
    co.scan @products[0]
    co.scan @products[2]
    expect(co.total).to be_eql(73.76)
  end
end
