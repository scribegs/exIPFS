defmodule ExIPFS.FileTest do
  use ExUnit.Case

  describe "add/2" do
    test "adds a file to IPFS" do
      temporary_file = System.tmp_dir! <> "temp_file.txt"
      File.open(temporary_file, [:write])
      assert ExIPFS.File.add(temporary_file)
    end
  end
end
