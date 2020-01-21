defmodule Cryptotracker.CryptoCompareApi do
    def fetchAPI() do
        resp = HTTPoison.get!("https://min-api.cryptocompare.com/data/pricemulti?fsyms=ETH,DASH,LTC&tsyms=BTC,USD,EUR")
        data = Poison.decode!(resp.body)
        end
        
    def fetchPrice(coinnames, currency) do
    string = Enum.join(coinnames, ",")
        resp = HTTPoison.get!("https://min-api.cryptocompare.com/data/pricemultifull?fsyms=#{string}&tsyms=#{currency}&api_key=1d2f8f2b8104989c9409bf8825e0622f378a26f5dfe1b36fac62343af2a6fd6e")
        data = Poison.decode!(resp.body)
        data = data["DISPLAY"]
    end
end