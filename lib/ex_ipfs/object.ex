defmodule ExIPFS.Object do
  @moduledoc ~S"""
  Defines interaction with IPFS Objects
  """

  @ipfs_api Application.get_env(:ex_ipfs, :url)

  defstruct hash: nil, data: nil, links: []

  @type t :: %__MODULE__{
    hash: String.t,
    data: String.t,
    links: list(ScribeNode.IPFS.Object.t)
  }

  @doc ~S"""
  Creates a new object on IPFS.

  [API Docs](https://ipfs.io/docs/api/#api-v0-object-new)

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

  [API Docs](https://ipfs.io/docs/api/#api-v0-object-new)

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
    call("object/new")
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
    resp = call("object/get?arg=" <> hash)

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

  # def add_link(object, name, link, create \\ false) do
  #   call("object/patch/add-link?arg=#{object}&arg=#{name}&arg=#{link}&create=#{create}")
  # end

  # ============================================================================
  # PRIVATE ====================================================================
  # ============================================================================

  defp format_response(%{body: body} = _resp) do
    resp = for {key, value} <- Poison.decode!(body), into: %{} do
      key
      |> String.downcase
      |> String.to_atom
      |> (& {&1, value}).()
    end

    case resp do
      %{code: _, message: _} ->
        Map.merge(%ExIPFS.Error{}, resp)

      resp ->
        Map.merge(%ExIPFS.Object{}, resp)
    end
  end

  defp call(path) do
    resp = HTTPoison.get!(@ipfs_api <> path)
    format_response(resp)
  end
end
