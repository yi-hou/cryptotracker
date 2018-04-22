defmodule CryptotrackerWeb.PageController do
  use CryptotrackerWeb, :controller

  alias Cryptotracker.{Mailer, Email}

  def index(conn, _params) do
    render conn, "index.html"
  end

  def home(conn, _params) do
    render conn, "home.html"
  end

  def select(conn, _params) do
    render conn, "selectcrypto.html"
  end

  def fetchAPI(conn, _params) do
    resp = HTTPoison.get!("https://min-api.cryptocompare.com/data/pricemulti?fsyms=ETH,DASH,LTC&tsyms=BTC,USD,EUR")
    data = Poison.decode!(resp.body)
    render conn, "home.html"
  end
  
  def fetchPrice(coinnames, currency) do
    string = Enum.join(coinnames, ",")
      resp = HTTPoison.get!("https://min-api.cryptocompare.com/data/pricemultifull?fsyms=#{string}&tsyms=#{currency}&e=CCCAGG")
      data = Poison.decode!(resp.body)
      data = data["DISPLAY"]
  end

  def alerts(conn, _params) do
    alerts = Cryptotracker.Notification.list_alerts()
    changeset = Cryptotracker.Notification.change_alert(%Cryptotracker.Notification.Alert{})
    render conn, "alerts.html", alerts: alerts, changeset: changeset
  end
end
