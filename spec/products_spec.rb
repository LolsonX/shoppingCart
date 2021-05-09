require "rspec"
require_relative "../shopping_cart/shopping_cart"

describe "Products" do

  context "when condition" do
    it "raise ArgumentError if price is invalid" do
      expect {
        ShoppingCart::Product.new("001",
                                  'test',
                                  'abc')
      }.to raise_error(ArgumentError)
    end
  end
end
