# AqBanking restful service

This is a sinatra based webservice which exposes basic aqbanking functionality using an easy to consume functionality.

# Running tests

To execute the full testsuite you need to check out the project and run

    $ bundle install
    $ bundle exec rake test

# Setup

You need to setup aqbanking properly first. See `aqbanking.md` for example steps.
Now, install all dependencies and execute foreman:

    $ bundle install
    $ bundle exec foreman start

The interface should be running. Request a list of all available accounts by executing

    $ curl "http://0.0.0.0:9292/accounts" -s

If you see JSON output you're good to go!

# Current State

The service currently can:

  - list all registered accounts
  - return latest transactions for a given account

# ToDo

- refresh transactions for all accounts in the background
- add api endpoint to register new accounts, wrapping aqbanking-cli