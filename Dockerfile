FROM bitwalker/alpine-elixir-phoenix:latest

WORKDIR /app

COPY mix.exs .
COPY mix.lock .

CMD mix deps.get && mix ecto.reset && mix update.avail && mix phx.server