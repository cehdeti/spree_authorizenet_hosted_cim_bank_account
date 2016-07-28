Spree Authorize.net Hosted CIM Bank Account
===========================================

Adds the ability to store bank accounts as payment methods through the
Authorize.net hosted CIM form.

To be used with the
[`spree_authorizenet_hosted_cim`](https://github.com/cehdeti/spree_authorizenet_hosted_cim) extension.

## Installation

1. Add this extension to your Gemfile with this line:
  ```ruby
  gem 'spree_authorizenet_hosted_cim_bank_account', github: 'cehdeti/spree_authorizenet_hosted_cim_bank_account'
  ```

2. Install the gem using Bundler:
  ```ruby
  bundle install
  ```

3. Copy & run migrations
  ```ruby
  bundle exec rails g spree_authorizenet_hosted_cim_bank_account:install
  ```

4. Restart your server

  If your server was running, restart it so that it can find the assets properly.

## Testing

First bundle your dependencies, then run `rake`. `rake` will default to building the dummy app if it does not exist, then it will run specs. The dummy app can be regenerated by using `rake test_app`.

```shell
bundle
bundle exec rake
```

When testing your applications integration with this extension you may use it's factories.
Simply add this require statement to your spec_helper:

```ruby
require 'spree_authorizenet_hosted_cim_bank_account/factories'
```


## Contributing

If you'd like to contribute, please take a look at the
[instructions](CONTRIBUTING.md) for installing dependencies and crafting a good
pull request.

Copyright (c) 2016 CEHD ETI, released under the New BSD License
