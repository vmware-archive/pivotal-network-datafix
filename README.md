# Datafix

Datafix provides a template generator for documenting and testing database hotfixes

## Installation

Add this line to your application's Gemfile:

    gem 'datafix', :github => 'Casecommons/datafix'

And then execute:

    $ bundle
    $ rails g datafix:install
    $ rake db:migrate

## Usage

Generate a timestamped datafix script with some boilerplate for execution.

    rails g datafix MyGroovyName

This will create:

    db/datafixes/YYYYMMDDhhmmss_my_groovy_name.rb

and

    spec/db/datafixes/YYYYMMDDhhmmss_my_groovy_name_spec.rb

To run it, execute:

    rake db:datafix[:up] NAME=my_groovy_name

or

    rake db:datafix[:up] NAME=MyGroovyName

run the down with:

    rake db:datafix:down NAME=my_groovy_name

To run the spec, execute:

    rspec spec/db/datafixes/YYYYMMDDhhmmss_my_groovy_name_spec.rb

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

