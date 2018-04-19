defmodule CryptotrackerWeb.PageController do
  use CryptotrackerWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end


  def home(conn, _params) do
    render conn, "home.html"
  end

  def fetchAPI(conn, _params) do
    resp = HTTPoison.get!("https://min-api.cryptocompare.com/data/pricemulti?fsyms=ETH,DASH,LTC&tsyms=BTC,USD,EUR")
    IO.inspect(resp)
    data = Poison.decode!(resp.body)
    IO.inspect(data)
    IO.inspect(data["DASH"]["BTC"])
    render conn, "home.html"
    IO.inspect(data |> Map.get("BTC") |> Map.get("USD") )
    IO.inspect(data |> Map.get("BTC") |> Map.get("USD")  |> Map.put("NAME", "baz"))
  
  end

  def fetchpricefromAPI() do
    resp = HTTPoison.get!("https://min-api.cryptocompare.com/data/pricemultifull?fsyms=BTC,ETH,BCH,LTC&tsyms=USD&e=Coinbase&extraParams=your_app_name")
  
    data = Poison.decode!(resp.body)
  
    data = data["DISPLAY"]
    IO.puts("DISPLAY")
   
    IO.puts("hi");
   
    data
    end 
   
    
    
  


  def fetchallpriceData() do
    resp = HTTPoison.get!("https://min-api.cryptocompare.com/data/pricemultifull?fsyms=BTC,XRP,BCH,LTC&tsyms=USD&e=Coinbase&extraParams=your_app_name")
    IO.inspect(resp)
    data = Poison.decode!(resp.body)
    IO.inspect(data)
    IO.inspect(data["DISPLAY"]["BTC"]["USD"]["LASTVOLUME"])  
 
 
    
  end
end
