FROM ruby:3.2.2

# Instala dependencias del sistema
RUN apt-get update -qq && \
    apt-get install -y curl gnupg2 postgresql-client build-essential && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn

WORKDIR /app
COPY . .

# Instala bundler y dependencias del proyecto
RUN gem install bundler && bundle install && yarn install

# Elimina el archivo que bloquea el arranque de Rails si quedó colgado
ENTRYPOINT ["bash", "-c", "rm -f tmp/pids/server.pid && exec \"$@\"", "--"]

# Comando por defecto
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
