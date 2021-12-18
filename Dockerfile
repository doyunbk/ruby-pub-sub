FROM ruby:3.0.2

ENV BUNDLER_VERSION=2.2.22
ENV REDIS_URL redis:6379

WORKDIR /project

COPY Gemfile /project/Gemfile
COPY Gemfile.lock /project/Gemfile.lock
RUN gem install bundler
RUN bundle install

COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]