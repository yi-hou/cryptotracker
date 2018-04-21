defmodule CryptotrackerWeb.PageController do
  use CryptotrackerWeb, :controller

  alias Cryptotracker.{Mailer, Email}

  def index(conn, _params) do
    render conn, "index.html"
  end


  def home(conn, _params) do
    #IO.puts("Sending email")
    #send_alert_email()
    #IO.puts("Email sent")
    render conn, "home.html"
  end


  def select(conn, _params) do
    render conn, "selectcrypto.html"
  end

  def fetchAPI(conn, _params) do
    resp = HTTPoison.get!("https://min-api.cryptocompare.com/data/pricemulti?fsyms=ETH,DASH,LTC&tsyms=BTC,USD,EUR")
    #IO.inspect(resp)
    data = Poison.decode!(resp.body)
    #IO.inspect(data)
    #IO.inspect(data["DASH"]["BTC"])
    render conn, "home.html"
    IO.inspect(data |> Map.get("BTC") |> Map.get("USD") )
    IO.inspect(data |> Map.get("BTC") |> Map.get("USD")  |> Map.put("NAME", "baz"))
  
  end
  
  def fetchPrice(coinnames, currency) do
    string = Enum.join(coinnames, ",")
      resp = HTTPoison.get!("https://min-api.cryptocompare.com/data/pricemultifull?fsyms=#{string}&tsyms=#{currency}&e=Coinbase&extraParams=your_app_name")
      data = Poison.decode!(resp.body)
      data = data["DISPLAY"]
      IO.inspect(data)
    end

  def alerts(conn, _params) do
    alerts = Cryptotracker.Notification.list_alerts()
    changeset = Cryptotracker.Notification.change_alert(%Cryptotracker.Notification.Alert{})
    render conn, "alerts.html", alerts: alerts, changeset: changeset
  end

  defp send_alert_email do
    Email.price_alert_email() |> Mailer.deliver_now()
  end
end
