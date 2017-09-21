defmodule Server do
	use GenServer


  #Server Callbacks
	@doc """
  Initializes the state and returns {:ok, state}
  """
  def init([]) do
  	#refs = %{}
  	{:ok, []}
  end

    
  def handle_cast({:print, coin_val, hash}, state) do
    IO.puts "#{coin_val}  #{hash}"
    {:noreply, state}
  end

  def handle_cast({:update_state, num_zeros}, state) do
    {:noreply, [num_zeros| state]}
  end

  def handle_call({:get_state}, _from, state) do
    {:reply, state, state}
  end

     


end