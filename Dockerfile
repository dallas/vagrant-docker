FROM ruby:2.2.0

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev \
  postgresql-client nodejs npm

# Rails app ?
COPY docker/rails/start-server.sh /start-server.sh
RUN chmod +x /start-server.sh

# Preinstall majority of gems
WORKDIR /tmp
COPY ./Gemfile Gemfile
COPY ./Gemfile.lock Gemfile.lock
RUN bundle install

WORKDIR /

RUN mkdir /app
COPY . /app

ENV RAILS_ENV development

COPY ./docker/rails/setup-database.sh /setup-database.sh
RUN chmod +x /setup-database.sh

CMD ["/start-server.sh"]
