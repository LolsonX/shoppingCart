module ShoppingCart
  # Product model
  class Product
    attr_reader :product_code, :name, :original_price
    attr_accessor :price

    # @param [String] product_code
    # @param [String] name
    # @param [Float] price
    def initialize(product_code, name, price)
      raise ArgumentError, "Price must be positive numeric" unless price.to_f.positive?
      @product_code = product_code
      @name = name
      @price = price
      @original_price = price
    end

    # Lower price
    # @param [Float] discount_value
    def discount(discount_value)
      @price = (1 - discount_value) * price
    end

    # Set new price
    # @param [Float] new_price
    def change_price(new_price)
      @price = new_price
    end

    # @return [String]
    def to_s
      "#{product_code} #{name}, cost: #{price}"
    end
  end
end
