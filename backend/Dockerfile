FROM ruby:3.2.2

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client yarn

WORKDIR /code
COPY . .

RUN gem install bundler && bundle install && apt-get install -y jq

CMD ["bin/rails", "server", "-b", "0.0.0.0", "-p", "4000"]