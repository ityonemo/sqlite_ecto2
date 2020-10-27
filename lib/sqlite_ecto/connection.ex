defmodule Sqlite.Ecto3.Connection do
  use DBConnection

  @impl true
  def connect(state) do
    {:ok, state}
  end

  def checkin(state) do
    {:ok, state}
  end

  def checkout(state) do
    {:ok, state}
  end

  def ping(state) do
    {:ok, state}
  end

end
