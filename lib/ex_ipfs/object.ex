defmodule ExIPFS.Object do
  @moduledoc ~S"""
  Defines interaction with IPFS Objects
  """

  defstruct hash: nil, data: nil, links: []

  @type t :: %__MODULE__{
    hash: String.t,
    data: String.t,
    links: list(ScribeNode.IPFS.Object.t)
  }

  alias ExIPFS.{Daemon}

  @doc ~S"""
  Creates a new object on IPFS.
  [IPFS Docs](https://ipfs.io/docs/api/#api-v0-object-new)

  ## Example

      ExIPFS.Object.new

      {:ok, %ExIPFS.Object{
        hash: "QmdfTbBqBPQ7VNxZEYEj14VmRuZBkqFbiwReogJgS1zR1n",
        data: nil,
        linkts: []
      }}

  """
  @spec new :: {:ok, ExIPFS.Object.t}
  def new do
    {:ok, new!()}
  end

  @doc ~S"""
  Same as new() except it returns just the result.
  [IPFS Docs](https://ipfs.io/docs/api/#api-v0-object-new)

  ## Example

      ExIPFS.Object.new!

      %ExIPFS.Object{
        hash: "QmdfTbBqBPQ7VNxZEYEj14VmRuZBkqFbiwReogJgS1zR1n",
        data: nil,
        linkts: []
      }

  """
  @spec new! :: [hash: String.t]
  def new! do
    Daemon.get("object/new")
  end

  @doc ~S"""
  Get object by hash
  [IPFS Docs](https://ipfs.io/docs/api/#api-v0-object-get)

  ## Example

      ExIPFS.Object.get("QmdfTbBqBPQ7VNxZEYEj14VmRuZBkqFbiwReogJgS1zR1n")

      {:ok, %ExIPFS.Object{
        hash: "QmdfTbBqBPQ7VNxZEYEj14VmRuZBkqFbiwReogJgS1zR1n"
        data: nil,
        links: []
      }}

  """
  @spec get(String.t) :: {:ok, ExIPFS.Object.t} | {:error, String.t}
  def get(hash) do
    resp = Daemon.get("object/get?arg=" <> hash)

    case resp do
      %ExIPFS.Object{} ->
        {:ok, %{resp | hash: hash}}

      _ ->
        {:error, resp.message}
    end
  end

  @doc ~S"""
  Get object by hash and return only the response
  [IPFS Docs](https://ipfs.io/docs/api/#api-v0-object-get)

  ## Example

      ExIPFS.Object.get("QmdfTbBqBPQ7VNxZEYEj14VmRuZBkqFbiwReogJgS1zR1n")

      %ExIPFS.Object{
        hash: "QmdfTbBqBPQ7VNxZEYEj14VmRuZBkqFbiwReogJgS1zR1n"
        data: nil,
        links: []
      }

  """
  @spec get!(String.t) :: [hash: String.t] | ExIPFS.Error.t
  def get!(hash) do
    case get(hash) do
      {:ok, res} -> res
      {:error, err} -> raise ExIPFS.Error, err
    end
  end

  # Data =======================================================================

  @doc ~S"""
  Set the data field of an IPFS Object
  [IPFS Docs](https://ipfs.io/docs/api/#api-v0-object-patch-set-data)

  ## Example

      ExIPFS.Object.set_data("QmdfTbBqBPQ7VNxZEYEj14VmRuZBkqFbiwReogJgS1zR1n", "example/test.file")

      QmdfTbBqBPQ7VNxZEYEj14VmRuZBkqFbiwReogJgS1zR1n

  """
  @spec set_data(String.t, String.t) :: String.t
  def set_data(hash, file) do
    Daemon.patch("object/patch/set-data?arg=#{hash}", file)
  end

  # Links ======================================================================

  @doc ~S"""
  Add a link to a given object.
  [IPFS Docs](https://ipfs.io/docs/api/#api-v0-object-patch-add-link)

  ## Example

      ExIPFS.Object.add_link("QmdfTbBqBPQ7VNxZEYEj14VmRuZBkqFbiwReogJgS1zR1n",
        "test", "QmVvapAWDbgBb3w1ujpGThQtiVmcMkFZLVkXEZp71pRVyX")

      QmdfTbBqBPQ7VNxZEYEj14VmRuZBkqFbiwReogJgS1zR1n

  """
  @spec add_link(String.t, String.t, String.t, boolean()) :: String.t
  def add_link(object, name, link, create \\ false) do
    Daemon.patch("object/patch/add-link?arg=#{object}&arg=#{name}&arg=#{link}&create=#{create}")
  end

  @doc ~S"""
  Remove a link from an object
  [IPFS Docs](https://ipfs.io/docs/api/#api-v0-object-patch-rm-link)

  ## Example

      ExIPFS.Object.remove_link("QmdfTbBqBPQ7VNxZEYEj14VmRuZBkqFbiwReogJgS1zR1n", "test")

      QmdfTbBqBPQ7VNxZEYEj14VmRuZBkqFbiwReogJgS1zR1n

  """
  @spec remove_link(String.t, String.t) :: String.t
  def remove_link(object, link_name) do
    Daemon.patch("object/patch/rm-link?arg=#{object}&arg=#{link_name}}")
  end
end
