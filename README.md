# Frecency

## Overview

Frecency is a Ruby on Rails gem that provides a way to sort models based on a combination of frequency and recency, also known as "frecency." This allows for more relevant sorting of records by considering both how often and how recently an item has been accessed or updated.

## Installation

To install the `frecency` gem, add it to your Gemfile in your Rails application:

```ruby
gem 'frecency'
```

Then, run the following command to install the gem:

```sh
bundle install
```

## Configuration

### Initializer Configuration

You need to configure your frecency gem in an initializer. Create a file named `frecency.rb` in your `config/initializers` directory:

```ruby
# config/initializers/frecency.rb
Frecency.configure do |config|
  config.default_frequency_column = :views_count  # Default column for frequency
  config.default_recency_column = :updated_at     # Default column for recency
  config.default_custom_frequency_scope = nil     # Default custom frequency scope (optional)
end
```

### Model Configuration

Next, configure the models that you want to utilize frecency sorting. You can do this by adding the necessary configuration to each model. Here’s how you can configure a model:

#### Basic Configuration

For basic configuration using default settings:

```ruby
class Product < ApplicationRecord
  configure_frecency(
    frequency: :views_count,        # Column calculating frequency
    recency: :updated_at      # Column calculating recency
  )
end
```

#### Custom Frequency Scope

If you need a custom frequency scope, you can specify it:

```ruby
class Order < ApplicationRecord
  belongs_to :product

  configure_frecency(
    frequency: :dynamic,      # Use dynamic frequency calculation
    recency: :created_at,     # Column calculating recency
    custom_frequency_scope: -> { 
      select("#{table_name}.*, COUNT(orders.id) as frequency")
      .joins(:orders)
      .group("#{table_name}.id")
    }
  )
end
```

## Usage

After configuring the gem, you can use the `frecency` method to fetch records sorted by frecency:

### Basic Usage

To retrieve top 10 products sorted by frecency:

```ruby
top_products = Product.frecency(10)
```

### Advanced Usage

You can define more complex configuration and filtering:

```ruby
class CustomModel < ApplicationRecord
  configure_frecency(
    frequency: :custom_count,               # Custom column for frequency
    recency: :last_accessed_at,             # Custom column for recency
    custom_frequency_scope: -> { 
      select("#{table_name}.*, custom_logic() as frequency")
    }
  )
end

top_records = CustomModel.frecency(20)

## Contributing

1. Fork the repository on GitHub.
2. Clone your forked repository.
3. Create a new branch for your feature or bug fix.
4. Write tests for your feature or bug fix.
5. Make your changes.
6. Run RSpec tests (or your preferred test suite).
7. Commit your changes and push to your fork.
8. Create a pull request on GitHub.

## License

This gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
