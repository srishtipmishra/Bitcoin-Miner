defmodule Client do
	use GenServer 
		

	def main(server_pid, k) do
		range = 1000000
		for i <- 0..range, do:
		spawn_link(fn -> mine(server_pid, k) end)
	end

	def mine(server_pid, k) do
		#First generate a random string
		rand_no1 = :crypto.strong_rand_bytes(10) |> Base.encode16
		rand_no2 = :crypto.strong_rand_bytes(10) |> Base.encode16
		input = "4124-3903;#{rand_no1}#{rand_no2}"

		#find the hash for the input
		hash = get_hash(input)

		status = get_leading_zeros(hash |> String.graphemes, 0) 
				|> check_zeros(k)

		if status == Elixir.True do
			GenServer.cast(server_pid, {:print, input, hash})
		end

		
	end


	def print_args(args) do
		IO.puts args

	end

	def get_hash(value) do
		:crypto.hash(:sha256, value)
		|>Base.encode16
		|>String.downcase
	end

	def get_leading_zeros(value, count) do
		[h|t] = value
		if h == "0" do
			get_leading_zeros(t, count+1)
		else 
			count
		end

	end

	def check_zeros(c, k) do
		if c >= k do
			True
		else
			False
		end


	end

	def max_zeros(c, k) do
		if c > k do
			c
		end
	end
end