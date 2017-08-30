FROM ruby:2.4.1-alpine
ENV LANG ja_JP.UTF-8

# 必要なツールの取得
RUN apk update && \
    apk upgrade && \
    apk add --update\
    bash \
    build-base \
    curl-dev \
    git \
    graphviz \
    less\
    libxml2-dev \
    libxslt-dev \
    linux-headers \
    mysql-dev \
    nodejs \
    openssh \
    ruby-dev \
    ruby-json \
    ttf-freefont \
    tzdata \
    yaml \
    yaml-dev \
    zlib-dev
RUN gem install bundler

RUN npm install -g yarn --no-progress

# bundle install
ARG BUNDLE_GITHUB__COM
ENV BUNDLE_GITHUB__COM $BUNDLE_GITHUB__COM
WORKDIR /tmp
COPY Gemfile /tmp
COPY Gemfile.lock /tmp
RUN bundle install

# workdir作成
ENV APP_HOME /myapp
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME
RUN yarn

# applicationの実行
COPY . $APP_HOME
EXPOSE 3000
CMD ["rails", "server", "-p", "3000", "-b", "0.0.0.0"]
