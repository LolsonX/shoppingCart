#ShoppingCart Task Solution

## Link to task
<a href="https://github.com/chrisface/ruby_shopping_cart">Task Description</a>

## Installation
### Prerequisites
* Ruby: 2.7.2
* Bundler 2.1.4

### Prepare gems
```bash
bundle install
```

##Usage
* To run described cases run ```ruby cases.rb```
* To run mini application just type ```ruby main.rb``` and program should start
* To run tests run ```rspec``` 

## Further improvements
Current mini app (main.rb) is not very good. It's more proof of concept to demonstrate example usage - it was written as fast as possible 
so there is no things like input validation, or method extraction.
* Store current discounts and products
* Create a kind of DSL to create new promotions and create more generic total price calculation
* Create GUI app (i.e. Simple web app) to enable more user friendly management