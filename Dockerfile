FROM ruby:2

VOLUME /usr/local/phantomjs

ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock

RUN apt-get update && apt-get install -y build-essential ruby-dev libffi-dev
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && apt-get install -y nodejs
RUN npm install -g phantomjs

RUN cd /app; bundle install
ADD . /app
WORKDIR /app

ENTRYPOINT ["ruby", "./main.rb"]
