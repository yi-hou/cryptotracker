defmodule Cryptotracker.PriceUpdater do
    use GenServer
    alias Cryptotracker.CryptoCompareApi

    # Attribution: Gazler on Stackoverflow for Genserver Timer Logic
    # Link: stackoverflow.com/questions/34948331

    def start_link() do
        GenServer.start_link(__MODULE__, %{})
    end

    def init(state) do
        data = CryptoCompareApi.fetchPrice(["BTC"],"USD")

        state = %{
            coinSymbols: ["BTC", "ETH", "XRP", "BCH", "EOS", "LTC", "ADA", "XLM", "NEO", "XMR", "DASH", "TRX", "XEM", "USDT", "VEN", "ETC", "QTUM", "BNB", "ICX", "LSK", "BTG", "PPT", "XVG"],
            coinNames: ["Bitcoin", "Ethereum", "Ripple", "Bitcoin Cash", "EOS", "Litecoin", "Cardano", "Stellar", "NEO", "Monero", "Dash", "TRON", "NEM", "Tether", "VeChain", "Ethereum Classic", "Qtum", "Binance Coin", "ICON", "Lisk", "Bitcoin Gold", "Populous", "Verge", "Zcash"],
        }

        # Attribution: Alex Garibay on STackoverflow for Genserver -> Channel Logic
        # Link: stackoverflow.com/questions/37106605

        updatePrices(state)
        timer = Process.send_after(self(), :work, 1_000)
        {:ok, %{timer: timer}}
    end

    defp updatePrices(state) do
        CryptotrackerWeb.Endpoint.broadcast! "room:lobby", "fetch_prices", state
    end

    def reset_timer() do
        GenServer.call(__MODULE__, :reset_timer)
    end

    def handle_call(:reset_timer, _from, %{timer: timer}) do
        :timer.cancel(timer)
        timer = Process.send_after(self(), :work, 1_000)
        {:reply, :ok, %{timer: timer}}
    end

    def handle_info(:work, state) do
        data = CryptoCompareApi.fetchPrice(["BTC"],"USD")
        state = %{
            coinSymbols: ["BTC", "ETH", "XRP", "BCH", "EOS", "LTC", "ADA", "XLM", "NEO", "XMR", "DASH", "TRX", "XEM", "USDT", "VEN", "ETC", "QTUM", "BNB", "ICX", "LSK", "BTG", "PPT", "XVG"],
            coinNames: ["Bitcoin", "Ethereum", "Ripple", "Bitcoin Cash", "EOS", "Litecoin", "Cardano", "Stellar", "NEO", "Monero", "Dash", "TRON", "NEM", "Tether", "VeChain", "Ethereum Classic", "Qtum", "Binance Coin", "ICON", "Lisk", "Bitcoin Gold", "Populous", "Verge", "Zcash"],
        }

        updatePrices(state)

        timer = Process.send_after(self(), :work,1_000)
        {:noreply, %{timer: timer}}
    end

    def handle_info(_, state) do
        {:ok, state}
    end

end