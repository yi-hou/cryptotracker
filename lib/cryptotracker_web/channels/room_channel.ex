defmodule CryptotrackerWeb.RoomChannel do
    use CryptotrackerWeb, :channel
  
    def join("room:lobby", _params, socket) do
      {:ok, socket}
    end

    def handle_in("fetch_prices_USD", payload, socket) do
        %{"coinnames" => coinnames, "state" => state} = payload
        
        
        IO.inspect(coinnames)
       
        data = CryptotrackerWeb.PageController.fetchpricefromAPIUSD(coinnames)
        IO.puts("data fetched from API")
        {:reply, {:ok, data}, socket}
    end
 
  end