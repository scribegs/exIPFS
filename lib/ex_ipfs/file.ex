defmodule ExIPFS.File do
  @moduledoc """
  """

  alias ExIPFS.{Daemon}

  @doc """
  Adds a file to IPFS

  ## Example
    IPFS.File.add("path/to/file")
    "hash of file"
  """
  @spec add(String.t) :: String.t
  def add(file_path) do
    Daemon.post("add", file: file_path)
  end
end
