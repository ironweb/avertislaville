# Rouges

## Getting started

Make sure you have the following dependencies installed:

- postgres & postgis
- ruby 1.9.3
- bundler

Then run :

    bundle install
    cp config/database.yml-tmp config/database.yml
    # change your database config accordingly
    cp config/open311.yml-tmp config/open311.yml
    # change your open311 config accordingly
    bundle exec rake db:create db:schema:load db:seed

## Deploy

    # New comer?
    cap setup
    cap unicorn:setup

    # SSH on sever, copy configs and edit them :
    cp current/config/database.yml-tmp shared/config/database.yml
    cp current/config/open311.yml-tmp shared/config/open311.yml

    # Old timer? Yeay, that simple :
    cap deploy
