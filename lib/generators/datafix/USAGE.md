## Description
    This generator will create a timestamped script with some boilerplate for execution.

## Example

    rails generate datafix MyGroovyName

This will create:

    db/datafixes/YYYYMMDDhhmmss_my_groovy_name.rb

To run it, execute:

    rake db:datafix NAME=my_groovy_name

or

    rake db:datafix NAME=MyGroovyName

run the down with:

    rake db:datafix:down NAME=my_groovy_name
