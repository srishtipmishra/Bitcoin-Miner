defmodule Project1 do
  
  
  @moduledoc """
  Documentation for Project1.
  """


  def main(args) do
    args
    [parsed_args|t] = parse_args(args)
    
    IO.puts parsed_args
    ip = get_ip()
    value = String.contains?(parsed_args, ".")
    #start the server
    {:ok, server} = GenServer.start_link(Server, [])
    IO.inspect(server)

    case value do
      true ->
        connect_to_server(String.to_atom(parsed_args), server)
      false ->
        num_zeros = String.to_integer(parsed_args)
        GenServer.cast(server, {:update_state, num_zeros})
        hostname = :"shubh@#{ip}"
        #IO.puts hostname
        Node.start(hostname)
        Node.set_cookie(hostname, :"bitcoin")       

        :global.sync()
        :global.register_name(:server, server)

        client_name = "client1"

        
        spawn(fn -> Client.main(server, num_zeros) end)
        #begin_work_client(server, num_zeros, 0, client_name)
        #GenServer.cast(server, {:print, client_name})


        #IO.puts "-----------------------------------------"
        Process.sleep(:infinity)
    end




    
    #Process.sleep(:infinity) 
  end

  def connect_to_server(ip, server) do
    IO.puts "Connecting to server from #{Node.self}......."
    cid = :crypto.strong_rand_bytes(10) |> Base.encode16
    user_name = "client#{cid}" 
    IO.puts(user_name)
    client_ip = get_ip()

    Node.start(:"#{user_name}@#{client_ip}")
    Node.set_cookie(:"#{user_name}@#{client_ip}", :"bitcoin")

    IO.puts "Client Address"
    IO.puts :"#{user_name}@#{client_ip}"

    server_addr = :"shubh@#{ip}" 

    case Node.connect(server_addr) do
      true -> :ok 
              IO.puts "Connected!"
      reason ->
        IO.puts "Could not connect to server : #{server_addr}, reason: #{reason}"
        System.halt(0)    
    end
    :global.sync()
    :global.registered_names
    pid = :global.whereis_name(:server)


    IO.puts "Our Server -->"
    IO.inspect(pid)


    [num_zeros|t] = GenServer.call(pid, {:get_state})
    
    
    Client.main(pid, num_zeros) 
  
  end


  defp parse_args(args) do
    {_, _, _} = OptionParser.parse(args,
       switches: [foo: :string]
    )
    args
  end

  
  def get_ip() do
    {:ok, ips} = :inet.getif()
    {ip_1,ip_2,ip_3,ip_4} =
        Enum.filter(ips , fn({{ip, _, _, _} , _t, _net_mask}) -> 
          ip != 127 end)
        |> Enum.map(fn {ip, _, _} -> ip end)
        |>List.last
    "#{ip_1}.#{ip_2}.#{ip_3}.#{ip_4}"        
  end  

end

defmodule Benchmark do
  def measure(function) do
    function
    |> :timer.tc
    |> elem(0)
    |> Kernel./(1_000_000)
  end
end