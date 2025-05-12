FROM decidim/decidim:0.29.3

WORKDIR /app
COPY . .

# Instala dependencias si hace falta
RUN bundle install
RUN yarn install --check-files

# Precompila assets (opcional para producción)
# RUN bundle exec rake assets:precompile

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
