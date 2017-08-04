defmodule ExIPFS.Daemon do
  @ipfs_api Application.get_env(:ex_ipfs, :url)

  def get(path) do
    resp = HTTPoison.get!(@ipfs_api <> path)
    format_response(resp)
  end

  def post(path, params \\ []) do
    resp = HTTPoison.post!(@ipfs_api <> path, {:multipart, params})

    resp
    |> format_response()
    |> Map.get(:hash)
  end

  def patch(path, params \\ []), do: post(path, params)

  # ============================================================================
  # PRIVATE ====================================================================
  # ============================================================================

  # When parsing the JSON response, format the response to an %{key: value} map
  # and apply the response to a matching struct.
  defp format_response(%{body: body, status_code: status_code} = _resp) do
    resp = body
      |> Poison.decode!()
      |> keys_to_atoms()

    case status_code do
      500 ->
        Map.merge(%ExIPFS.Error{}, resp)

      200 ->
        Map.merge(%ExIPFS.Object{}, resp)
    end
  end

  defp keys_to_atoms(map) when is_map(map) do
    for {key, value} <- map, into: %{} do
      key
      |> String.downcase
      |> String.to_atom
      |> (& {&1, keys_to_atoms(value)}).()
    end
  end

  defp keys_to_atoms(list) when is_list(list) do
     Enum.map(list, &keys_to_atoms/1)
  end

  defp keys_to_atoms(val), do: val
end
