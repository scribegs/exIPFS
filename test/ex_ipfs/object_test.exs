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

  describe "set_data/2" do
    test "it sets the data field of an IPFS object" do
      %{hash: hash} = Object.new!
      new_hash = Object.set_data(hash, file: "test/data/test.file")

      assert Object.get!(new_hash).data == "Test"
    end
  end

  describe "add_link/4" do
    test "it adds a link to a given object" do
      %{hash: base} = Object.new!
      %{hash: link} = Object.new!

      %{links: [target]} = base
        |> Object.add_link("test", link)
        |> Object.get!()

        assert target.name == "test"
    end
  end

  describe "remove_link/2" do
    @tag :focus
    test "it removes a link from a given object" do
      %{hash: base} = Object.new!
      %{hash: link} = Object.new!

      obj = base
        |> Object.add_link("test", link)
        |> Object.get!()
        |> Map.get(:hash)
        |> Object.remove_link("test")

    end
  end
end
