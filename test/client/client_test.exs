defmodule BitcoinMiner.ClientTest do
	use ExUnit.Case, async: true

	setup do
		{:ok, server} = start_supervised BitcoinMiner.Server
		%{server: server}
	end

	test "client worker start the mining", %{server: server} do
		k = 1
		#Start the client
		client_name = "client1"
		BitcoinMiner.Client.start_client(server, client_name)

		#get the hash-bucket from server associated with the client
		{:ok, client_bucket} = BitcoinMiner.Client.lookup_clientid_in_server(server, client_name)

		#Generate the bitcoins for the client and update client's bucket
		BitcoinMiner.Client.gen_coin_and_update_bucket_server(client_bucket, k)
		
	end


	test "spawn multiple clients new", %{server: server} do
		k = 1
		input = "Shubham123"

		#Start the client
		client_name = "a"

		BitcoinMiner.Client.start_client(server, client_name)
		{:ok, client_bucket} = BitcoinMiner.Client.lookup_clientid_in_server(server, client_name)
			
		BitcoinMiner.Client.gen_coin_frm_ip_and_update_bucket_server(client_bucket, input,  k)

		#Generate more bitcoins
		for i <- 0..50, do:
		spawn_link(fn -> BitcoinMiner.HashBucket.gen_rand_coin_update_bucket(client_bucket, k) end)

		"""
		IO.puts "All coins from #{client_name} : "
		Enum.each(BitcoinMiner.Client.get_all_coins_from_bucket(client_bucket), fn post -> 
			IO.inspect post
		end)

		IO.puts "---------------------"
		

		#Start the client
		client_name = "b"

		BitcoinMiner.Client.start_client(server, client_name)
		{:ok, client_bucket} = BitcoinMiner.Client.lookup_clientid_in_server(server, client_name)
			
		BitcoinMiner.Client.gen_coin_frm_ip_and_update_bucket_server(client_bucket, input,  k)

		#Generate more bitcoins
		for i <- 0..50, do:
		spawn_link(fn -> BitcoinMiner.HashBucket.gen_rand_coin_update_bucket(client_bucket, k) end)

		"""
		IO.puts "All coins from #{client_name} : "
		Enum.each(BitcoinMiner.Client.get_all_coins_from_bucket(client_bucket), fn post -> 
			IO.inspect post
		end)
		"""
			
			
	end

	test "mine coins from client", %{server: server} do
		k = 1
		input = "Shubham123"

		for j <- 0..1, do:
		spawn(fn -> 
			client_name = "client#{j}"

			IO.puts "All Coins from #{client_name} : "
			Enum.each(BitcoinMiner.Client.start_mining(server, client_name, input, k), fn bucket -> 
				IO.inspect bucket
			end)

			IO.puts "---------------------"
		end)

	end

	
end