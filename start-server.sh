#!/bin/bash
cd /app
bundle install
bundle exec rake db:create db:migrate db:seed
bundle exec unicorn -p 3000
