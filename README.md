# Rouges

## Getting started

Make sure you have the following dependencies installed:

- postgres & postgis
- ruby 1.9.3
- bundler

Then run :

    bundle install
    cp config/database.yml-tmp config/database.yml
    # change your config accordingly
    bundle exec rake db:create db:schema:load db:seed
