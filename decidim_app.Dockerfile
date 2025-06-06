FROM ruby:3.2.2

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client yarn

WORKDIR /app
COPY ./decidim_app /app

RUN gem install bundler && bundle install

CMD ["bin/rails", "server", "-b", "0.0.0.0"]