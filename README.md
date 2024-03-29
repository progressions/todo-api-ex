# Todoable



## Installation

Clone the repository:

```bash
git clone git@github.com:progressions/todo-api-ex.git
cd todo-api-ex
```

Install dependencies:

```bash
mix deps.get
```

Set environment variables to your Postgres configuration:

```bash
PGUSER=username
PGPASSWORD=password
PGHOST=localhost
PGDATABASE=todo_api_dev
```

Create and migrate databases for development and test environments:

```bash
mix ecto.create
mix ecto.migrate

MIX_ENV=test mix ecto.create
MIX_ENV=test mix ecto.migrate
```

Run the seeds script to create a user with the username: "username", and password: "password".

```bash
mix run ./priv/repo/seeds.exs
```

Start the server:

```bash
mix phx.server
```

Your Todoable API server can now be reached at `localhost:4000/api`.


Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/todoable](https://hexdocs.pm/todoable).

