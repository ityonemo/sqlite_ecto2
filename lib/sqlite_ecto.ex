defmodule Sqlite.Ecto3 do
  @moduledoc ~S"""
  Ecto 3 Adapter module for SQLite.

  It uses Sqlitex and Esqlite for accessing the SQLite database.

  ## Configuration Options

  When creating an `Ecto.Repo` that uses a SQLite database, you should configure
  it as follows:

  ```elixir
  # In your config/config.exs file
  config :my_app, Repo,
    adapter: Sqlite.Ecto2,
    database: "ecto_simple.sqlite3"

  # In your application code
  defmodule Repo do
    use Ecto.Repo,
      otp_app: :my_app,
      adapter: Sqlite.Ecto2
  end
  ```

  You may use other options as specified in the `Ecto.Repo` documentation.

  Note that the `:database` option is passed as the `filename` argument to
  [`sqlite3_open_v2`](http://sqlite.org/c3ref/open.html). This implies that you
  may use `:memory:` to create a private, temporary in-memory database.

  See also [SQLite's interpretation of URI "filenames"](https://sqlite.org/uri.html)
  for more options such as shared memory caches.
  """

  def start_link(opts) do
    DBConnection.start_link(Sqlite.Ecto3.Connection, opts)
  end
end
