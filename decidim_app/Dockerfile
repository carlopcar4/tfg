FROM ruby:3.2.2

RUN apt-get update -qq && \
    apt-get install -y curl gnupg2 postgresql-client && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn

WORKDIR /app
COPY . .

RUN gem install bundler && bundle install

CMD ["bin/rails", "server", "-b", "0.0.0.0"]
