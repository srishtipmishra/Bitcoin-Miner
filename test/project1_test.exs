defmodule Project1Test do
  use ExUnit.Case
  doctest Project1

  test "greets the world" do
    assert Project1.hello() == :world
  end

  test "SHA-256 hashing" do
  	value = "Shubham123"
  	assert Project1.BitcoinMiner.get_hash(value) == "05f2bd2e80f900976788c4e4b483da1e3ac2d477f2a7345b6e484495aed2107a"
  end

  test "Hash Leading Zeros" do
  	value = "62b35d71cbcd23b4fd2c5f0360b4d6510ee244272fb40966ddbe47479810b4dc" 
  		assert Project1.BitcoinMiner.get_leading_zeros(value |> String.graphemes, 0) == 0
  	end

  test "test process" do
	for i <- 0..10, do:
	spawn(fn -> Project1.BitcoinMiner.start_process(1) end)
		
  end

end
