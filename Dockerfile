FROM ruby:3.0.4

# System prerequisites
RUN apt-get update \
 && apt-get -y install build-essential libpq-dev \
 && rm -rf /var/lib/apt/lists/*

# If you require additional OS dependencies, install them here:
# RUN apt-get update \
#  && apt-get -y install imagemagick nodejs \
#  && rm -rf /var/lib/apt/lists/*

ADD Gemfile /app/
ADD Gemfile.lock /app/
WORKDIR /app
RUN bundle install

ADD . /app

# Collect assets. This approach is not fully production-ready, but
# will help you experiment with Aptible before bothering with assets.
# Review http://go.aptible.com/assets for production-ready advice.
RUN set -a \
 && . ./.aptible.env \
 && bundle exec rake assets:precompile

EXPOSE 3000
