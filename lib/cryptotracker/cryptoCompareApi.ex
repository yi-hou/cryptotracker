defmodule Cryptotracker.CryptoCompareApi do
    def fetchAPI() do
        resp = HTTPoison.get!("https://min-api.cryptocompare.com/data/pricemulti?fsyms=ETH,DASH,LTC&tsyms=BTC,USD,EUR")
        data = Poison.decode!(resp.body)
        end
        
    def fetchPrice(coinnames, currency) do
    string = Enum.join(coinnames, ",")
        resp = HTTPoison.get!("https://min-api.cryptocompare.com/data/pricemultifull?fsyms=#{string}&tsyms=#{currency}&e=CCCAGG")
        data = Poison.decode!(resp.body)
        data = data["DISPLAY"]
    end
end