require "rspec"
require_relative "../shopping_cart/shopping_cart"

describe "ProductCountDiscount" do
  context "when params are invalid" do
    it "raise ArgumentError if new_value and new_val_factor is invalid" do
      expect {
        ShoppingCart::ProductCountDiscount.new("001",
          5,
          new_value: nil,
          new_val_factor: nil)
      }.to raise_error(ArgumentError)
    end
    it "raise ArgumentError if minimal_count is invalid" do
      expect {
        ShoppingCart::ProductCountDiscount.new("001",
          "asd",
          new_value: 1.0,
          new_val_factor: 1.0)
      }.to raise_error(ArgumentError)
    end

    it "raise ArgumentError if product code is invalid" do
      expect {
        ShoppingCart::ProductCountDiscount.new(1,
          1,
          new_value: 1.0,
          new_val_factor: 1.0)
      }.to raise_error(ArgumentError)
    end
  end
end

describe "TotalDiscount" do
  context "when params are invalid" do
    it "raise ArgumentError for invalid threshold" do
      expect {
        ShoppingCart::TotalDiscount.new("abc",
          1.0,
          "abc")
      }.to raise_error(ArgumentError)
    end
    it "raise ArgumentError for invalid discount" do
        expect {
          ShoppingCart::TotalDiscount.new("abc",
            "abc",
            1.0)
        }.to raise_error(ArgumentError)
      end
  end
end
