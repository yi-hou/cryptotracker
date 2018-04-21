defmodule CryptotrackerWeb.RoomChannel do
    use CryptotrackerWeb, :channel
  
    def join("room:lobby", _params, socket) do
      {:ok, socket}
    end

    def handle_in("fetch_prices", payload, socket) do
        %{"coinnames" => coinnames, "currency" => currency, "state" => state} = payload
        data = CryptotrackerWeb.PageController.fetchPrice(coinnames, currency)
        {:reply, {:ok, data}, socket}
    end
 
  end