module ShoppingCart
  # Stores information about current promotions and current cart
  class Checkout
    # @return [Discounts]
    attr_reader :promotion_rules
    # @return [Array]
    attr_reader :cart

    # @param [Discounts] promotion_rules
    # @return [ShoppingCart::Discounts]
    def initialize(promotion_rules)
      @cart = []
      @promotion_rules = promotion_rules
    end

    # Add item to basket and looks if there is discount on it
    # @return [Array]
    def scan(item)
      cart_item = item.dup
      @cart << calculate_discounts(cart_item)
    end

    # Return total basket cost
    # @return [Integer, Float]
    def total
      total_discount(@cart.sum { |item| item.price }).round(2)
    end

    private

    # Change prices in current basket
    # @param [Product] item
    # @param [ProductCountDiscount] count_rule
    # @return [nil]
    def modify_prices(item, count_rule)
      items = @cart.select { |c_item| c_item.product_code == item.product_code }
      items.map! do |c_item|
        count_rule.new_val_factor.nil? ? c_item.price = count_rule.new_value : c_item.price *= count_rule.new_val_factor
        c_item
      end
      item.price = count_rule.new_value
    end

    # Calculate new values if multiple items promotion is found
    # @param [Product] item
    # @return [Product]
    def calculate_discounts(item)
      count_rules = promotion_rules.find_count_discounts(item)
      count_rules.each do |count_rule|
        if @cart.count { |c_item| c_item.product_code == item.product_code } >= count_rule.minimal_count - 1
          modify_prices(item, count_rule)
        end
      end
      item
    end

    # Discounts if there is a promotion above some threshold
    # @param [Numeric] sum
    # @return [Integer]
    def total_discount(sum)
      discount = promotion_rules.find_total_discount(sum)
      (1 - discount) * sum
    end
  end
end

