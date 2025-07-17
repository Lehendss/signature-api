FROM ruby:3.2.8-slim
WORKDIR /app

# Instalamos dependencias del sistema y el compilador de Protobuf,
# y el gem grpc-tools para generar stubs gRPC en Ruby
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs libyaml-dev protobuf-compiler && \
    gem install grpc-tools

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 4

COPY . .

CMD ["bin/rails", "server", "-b", "0.0.0.0"]
