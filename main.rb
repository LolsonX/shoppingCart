require "curses"

require_relative "shopping_cart/shopping_cart"

include ShoppingCart

Curses.init_screen
Curses.start_color
Curses.curs_set 0
Curses.noecho

Curses.init_pair 1, 1, 0

def blank_screen
  @win.setpos(0, 0)
  (@win.maxy - @win.cury).times { @win.deleteln }
end

def add_product
  Curses.echo
  blank_screen
  @win.refresh
  @win << "Enter product code: "
  code = @win.getstr
  @win << "Enter product name: "
  name = @win.getstr
  @win << "Enter product price: "
  price = @win.getstr.to_f
  @products << Product.new(code, name, price)
  Curses.noecho
end

def draw_main_menu
  @win << "a - add product | s - list products | d - list basket| f - add to basket | g - add promotion| h - list promotion | j - summarize basket| q - quit \n"
end

def list_products
  @products.each { |product| @win << product.to_s }
end

def list_basket
  blank_screen
  @win.refresh
  @co.cart.each_with_index { |product, index| @win << "#{index + 1} #{product} \n" }
  @win.refresh
  @win << "Press any key to continue..."
  @win.getch
end

def add_to_basket
  Curses.echo
  blank_screen
  @win.refresh
  @products.each_with_index { |product, index| @win << "#{index + 1} #{product} \n" }
  selected = @win.getstr.to_i
  @co.scan(@products[selected - 1])
  Curses.noecho
end

def add_total_promotion
  Curses.echo
  blank_screen
  @win.refresh
  @win << "Enter promotion name: "
  name = @win.getstr
  @win << "Enter discount: (10% = 0.1): "
  discount = @win.getstr.to_f
  @win << "Enter minimal basket value: "
  value = @win.getstr.to_f
  @promotions.add_total_discount(name, discount, value)
  Curses.noecho
end

def add_multi_promotion
  Curses.echo
  blank_screen
  @win.refresh
  @win << "Enter product code: "
  product = @win.getstr
  @win << "Enter required minimal value: "
  minimal_count = @win.getstr.to_i
  @win << "Enter new value: (Leave blank if You want to change price with percentage)"
  value = @win.getstr
  if value == ""
    @win << "Enter discount: (10% = 0.1)"
    factor = @win.getstr.to_f
    @promotions.add_product_count_discount(product, minimal_count, new_val_factor: factor)

  else
    @promotions.add_product_count_discount(product, minimal_count, new_value: value.to_f)
  end
  Curses.noecho
end

def add_promotion
  blank_screen
  @win.refresh
  @win << "Enter total discount (t) or multiple products discount(u) other will exit"
  str = @win.getch.to_s # Reads and returns a character

  case str
  when "t"
    add_total_promotion
  when "u" then add_multi_promotion
  else
    return nil
  end
  @co = Checkout.new(@promotions)
end

def list_promotions
  blank_screen
  @win.refresh
  @win << "Total Discounts\n"
  @promotions.total_discounts.each_with_index { |p, i| @win << "\t#{i + 1} #{p}\n" }
  @win << "Multiple Items Discounts\n"
  @promotions.product_count_discounts.each_with_index { |p, i| @win << "\t#{i + 1} #{p}\n" }
  @win << "Press any key to continue\n"
  @win.getch
end

begin
  @win = Curses::Window.new(0, 0, 1, 2)
  @products = [
    Product.new("001", "Red Scarf", 9.25),
    Product.new("002", "Silver cufflinks", 45.00),
    Product.new("003", "Silk Dress", 19.95)
  ]
  @promotions = Discounts.new
  @promotions.add_total_discount("X-Mas10", 0.10, 60)
  @promotions.add_product_count_discount("001", 2, new_value: 8.50)
  @co = Checkout.new(@promotions)
  loop do
    draw_main_menu
    @win << "Current basket value (after discounts): € #{@co.total}"
    @win.setpos(0, 0)
    str = @win.getch.to_s # Reads and returns a character
    case str
    when "a"
      add_product
    when "s"
      list_products
    when "d"
      list_basket
    when "f"
      add_to_basket
    when "g"
      add_promotion
    when "h"
      list_promotions
    when "q" then exit 0
    else
      next
    end
    blank_screen
    @win.refresh
  end
ensure
  Curses.close_screen
end
