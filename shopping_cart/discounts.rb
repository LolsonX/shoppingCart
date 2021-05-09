module ShoppingCart
  # Discounts(Promotions) management
  class Discounts
    attr_reader :product_count_discounts
    attr_reader :total_discounts

    def initialize
      @product_count_discounts = []
      @total_discounts = []
    end

    # Adds new promotion for multiple items (Example if there are 2 scarfs set price to $10)
    # @param [String] product
    # @param [Integer] minimal_count
    # @param [nil, Float] new_value
    # @param [nil, Float] new_val_factor
    # @return [Array]
    def add_product_count_discount(product, minimal_count, new_value: nil, new_val_factor: nil)
      product_count_discounts << ProductCountDiscount.new(product,
        minimal_count.to_i,
        new_value: new_value,
        new_val_factor: new_val_factor)
    end

    # Adds new promotion for total value (Example if value is greater than 10$ whole basket is 10% off)
    # @param [Float] threshold
    # @param [Float] discount
    # @param [String] name
    # @return [Array]
    def add_total_discount(name, discount, threshold)
      total_discounts << TotalDiscount.new(name, discount, threshold)
    end

    # Find multiple items promotion
    # @param [Product] product
    # @return [Array]
    def find_count_discounts(product)
      @product_count_discounts.select { |pr| pr.product == product.product_code }
    end

    # Find total promotion
    # @param [Float] sum
    # @return [Integer]
    def find_total_discount(sum)
      discount = @total_discounts.select { |disc| disc.threshold <= sum }.max{|disc| disc.threshold.to_i}
      discount.nil? ? 0 : discount.discount
    end
  end

  class ProductCountDiscount
    attr_reader :product, :minimal_count, :new_value, :new_val_factor


    # @param [nil, Float] new_val_factor
    # @param [nil, Float] new_value
    # @param [Integer] minimal_count
    # @param [String] product
    def initialize(product, minimal_count, new_value: nil, new_val_factor: nil)
      parse_params(product, minimal_count, new_value, new_val_factor)
      @product = product
      @minimal_count = minimal_count
      @new_value = new_value
      @new_val_factor = new_val_factor
    end

    # @return [String]
    def to_s
      "Discounted product code: #{product}, minimal amount: #{minimal_count} new price: #{(new_value || "discounted by #{new_val_factor*100}%")}"
    end

    private

    # @param [nil ,Float] new_val_factor
    # @param [nil, Float] new_value
    # @param [Integer] minimal_count
    # @param [String] product
    # @return [Object]
    def parse_params(product, minimal_count, new_value, new_val_factor)
      raise ArgumentError, "New value or new value factor must be specified" if new_value.nil? && new_val_factor.nil?
      raise ArgumentError, "New value must be numeric or numeric string" if !new_value.nil? && !new_value.is_number?
      raise ArgumentError, "New value factor must be numeric or numeric string" if !new_val_factor.nil? && !new_val_factor.is_number?
      raise ArgumentError, "Minimal count must be integer" unless  minimal_count.is_a? Integer
      raise ArgumentError, "Product must be a product code string" unless  product.is_a? String
    end
  end

  class TotalDiscount
    attr_reader :discount, :threshold, :name
    # @param [Float] threshold
    # @param [Float] discount
    # @param [String] name
    def initialize(name, discount, threshold)
      @name = name
      discount.is_number? ? @discount = discount : raise(ArgumentError, "Discount must be a number")
      threshold.is_number? ? @threshold = threshold : raise(ArgumentError, "Threshold must be a number")
    end

    # @return [String]
    def to_s
      "#{name} - Price is lower by #{discount * 100}% if basket value is above #{threshold}"
    end
  end
end
