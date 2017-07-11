defmodule ExIPFS.ObjectTest do
  use ExUnit.Case

  alias ExIPFS.Object

  describe "new/0" do
    test "it creates a new IPFS object" do
      assert Object.new 
    end

    test "it can be called with a !"  do
      assert Object.new!
    end
  end

  describe "get/1" do
    test "it fetches an object from IPFS" do
      %{hash: hash} = Object.new!

      assert Object.get(hash) ==
        {:ok, %ExIPFS.Object{
          data: "",
          hash: hash,
          links: []
        }}
    end

    test "it returns a tuple containing an error if the object is not found" do
      hash = "totally_fake_hash"
      assert Object.get(hash) == {:error, "invalid 'ipfs ref' path"}
    end
  end

  describe "get!/1" do
    test "it fetches an object from IPFS" do
      %{hash: hash} = Object.new!

      assert Object.get!(hash) == 
        %ExIPFS.Object{
          data: "",
          hash: hash,
          links: []
        }
    end

    test "it raises an the error if the hash is invalid" do
      hash = "totally_fake_hash"

      assert_raise ExIPFS.Error, "invalid 'ipfs ref' path", fn ->
        Object.get!(hash)
      end
    end
  end

  # describe "add_link_to_object" do
  #   test "it adds a link to object" do
  #     %{hash: base_object} = Object.new
  #     %{hash: linked_object} = Object.new
  #     %{hash: target} = Object.add_link(base_object, "test", linked_object)
  #     %{links: [result]} = Object.get(target)

  #     assert Map.get(result, "Name") == "test"
  #     assert Map.has_key?(result, "Hash")
  #   end
  # end
end