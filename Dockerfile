FROM bitwalker/alpine-elixir-phoenix:1.8.0

RUN apk update \
  && apk add --no-cache postgresql-client \
  && rm -rf /var/cache/apk/*

ARG MIX_ENV=dev
ENV MIX_ENV ${MIX_ENV}
ENV SECRET_KEY_BASE "1234"

# Set exposed ports
EXPOSE 4000
ENV PORT=4000

# Create app directory and copy the Elixir projects into it
RUN mkdir /app
WORKDIR /app

RUN mkdir /app/log

ADD . ./

# Get deps & compile project
RUN mix deps.get \
  && MIX_ENV=test mix compile \
  && mix release

RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]

CMD ["mix", "phx.server"]
