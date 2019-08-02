FROM elixir:1.8.2-slim

WORKDIR /sports-app

ENV DATABASE_URL database

COPY . /sports-app

EXPOSE 4000
EXPOSE 8080

RUN apt-get update
RUN apt-get install git -y

RUN mix local.rebar --force
RUN mix local.hex --force
RUN mix deps.get --force
RUN mix compile

CMD mix
