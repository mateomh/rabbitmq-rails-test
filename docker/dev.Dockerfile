ARG RUBY_VERSION=3.1.2
FROM ruby:$RUBY_VERSION

RUN apt-get update -qq && \
    apt-get install -y ca-certificates && \
    update-ca-certificates && \
    apt-get install -y build-essential libvips && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man

WORKDIR /api

ENV RAILS_LOG_TO_STDOUT="1" \
    BUNDLE_PATH="/usr/local/bundle"

COPY Gemfile* ./
RUN gem install bundler
RUN bundle install

COPY . .

RUN bundle exec bootsnap precompile --gemfile app/ lib/

EXPOSE 3000

# CMD ./bin/rails server -b 0.0.0.0