defmodule Ecto.Adapters.Sqlite do
  @moduledoc """
  Adapter module for SQLite.
  It uses `sqlitex` for communicating to the database.
  """

  use Ecto.Adapters.SQL
    driver: :sqlite_ecto2

  @behaviour Ecto.Adapter.Storage
  @behaviour Ecto.Adapter.Structure

  @doc """
  there are currently no Ecto extensions for Sqlite
  """
  def extensions, do: []

  @impl true
  def dumpers(:binary, type), do: [type, &blob_encode/1]
  def dumpers(:binary_id, type), do: [type, Ecto.UUID]
  def dumpers(:boolean, type), do: [type, &bool_encode/1]
  def dumpers({:embed, _} = type, _), do: [&Ecto.Adapters.SQL.dump_embed(type, &1)]
  def dumpers(:time, type), do: [type, &time_encode/1]
  def dumpers(_primitive, type), do: [type]

  defp blob_encode(value), do: {:ok, {:blob, value}}

  defp bool_encode(false), do: {:ok, 0}
  defp bool_encode(true), do: {:ok, 1}

  defp time_encode(value), do: {:ok, value}

  ## Storage API

  @impl true
  def storage_up(opts) do
    storage_up_with_path(Keyword.get(opts, :database), opts)
  end

  defp storage_up_with_path(nil, opts) do
    raise ArgumentError,
      """
      No SQLite database path specified. Please check the configuration for your Repo.
      Your config/*.exs file should have something like this in it:

        config :my_app, MyApp.Repo,
          adapter: Sqlite.Ecto2,
          database: "/path/to/sqlite/database"

      Options provided were:

      #{inspect opts, pretty: true}

      """
  end

  defp storage_up_with_path(database, _opts) do
    if File.exists?(database) do
      {:error, :already_up}
    else
      database |> Path.dirname |> File.mkdir_p!
      {:ok, db} = Sqlitex.open(database)
      :ok = Sqlitex.exec(db, "PRAGMA journal_mode = WAL")
      {:ok, [[journal_mode: "wal"]]} = Sqlitex.query(db, "PRAGMA journal_mode")
      Sqlitex.close(db)
      :ok
    end
  end

  @impl true
  def storage_down(opts) do
    database = Keyword.get(opts, :database)
    case File.rm(database) do
      {:error, :enoent} ->
        {:error, :already_down}
      result ->
        File.rm(database <> "-shm") # ignore results for these files
        File.rm(database <> "-wal")
        result
    end
  end

  @impl Ecto.Adapter.Storage
  def storage_status(opts) do
    database = Keyword.fetch!(opts, :database) || raise ":database is nil in repo configuration"

    IO.warn("""
    Ecto.Adapters.Sqlite.storage_status/1 has not been completed.

    It was called with options #{inspect opts}.
    """)

    # temporarily report only "up"
    :up
  end

  @impl true
  def supports_ddl_transaction?, do: true

  @impl true
  def structure_dump(default, config) do
    raise "unimplemented"
  end

  @impl true
  def structure_load(default, config) do
    raise "unimplemented"
  end

end
