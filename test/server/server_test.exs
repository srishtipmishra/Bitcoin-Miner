defmodule BitcoinMiner.ServerTest do
	use ExUnit.Case, async: true


	setup do
		{:ok, registry} = start_supervised BitcoinMiner.Server
		%{registry: registry}
	end

	test "spawns buckets", %{registry: registry} do
		client_name = "client1"
		assert BitcoinMiner.Server.lookup(registry, client_name) == :error

		BitcoinMiner.Server.create(registry, client_name)
		assert {:ok, client_bucket} = BitcoinMiner.Server.lookup(registry, client_name)

		BitcoinMiner.HashBucket.put(client_bucket, "shubham", "0agethjhsjdfsdd")
		assert BitcoinMiner.HashBucket.get(client_bucket, "shubham") == "0agethjhsjdfsdd"

	end

	test "check if generated coin is updated to bucket", %{registry: registry} do
		client_name = "client1"
		input = "Shubham123"
		k = 1

		BitcoinMiner.Server.create(registry, client_name)
		assert {:ok, client_bucket} = BitcoinMiner.Server.lookup(registry, client_name)

		BitcoinMiner.HashBucket.gen_coin_update_bucket(client_bucket, input, k)
		assert BitcoinMiner.HashBucket.get(client_bucket, input) == "05f2bd2e80f900976788c4e4b483da1e3ac2d477f2a7345b6e484495aed2107a"


		BitcoinMiner.HashBucket.gen_coin_update_bucket(client_bucket, "shubham", 1)
		assert BitcoinMiner.HashBucket.get(client_bucket, "shubham") == nil
	end	

	test "spawn mutiple workers in parallel to generate coin", %{registry: registry}  do
		client_name = "client1"
		k = 1

		BitcoinMiner.Server.create(registry, client_name)
		assert {:ok, client_bucket} = BitcoinMiner.Server.lookup(registry, client_name)

		#IO.puts "In Parallel : " 
		Benchmark.measure(fn ->
			for i <- 0..100, do:
			spawn(fn -> BitcoinMiner.HashBucket.gen_rand_coin_update_bucket(client_bucket, k) end)end) 
		
	end

	test "Run mutiple workers in sequence to generate coin", %{registry: registry}  do
		client_name = "client1"
		k = 1

		BitcoinMiner.Server.create(registry, client_name)
		assert {:ok, client_bucket} = BitcoinMiner.Server.lookup(registry, client_name)

		#IO.puts "In Sequence : " 
		Benchmark.measure(fn ->
		for i <- 0..100, do:
		BitcoinMiner.HashBucket.gen_rand_coin_update_bucket(client_bucket, k)
		end) 
	end

end