defmodule CryptotrackerWeb.AlertController do
  use CryptotrackerWeb, :controller

  alias Cryptotracker.{Mailer, Email}
  alias Cryptotracker.Notification
  alias Cryptotracker.Notification.Alert

  def index(conn, _params) do
    alerts = Notification.list_alerts()
    render(conn, "index.html", alerts: alerts)
  end

  def new(conn, _params) do
    changeset = Notification.change_alert(%Alert{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"alert" => alert_params}) do
    #current_user = conn.assigns.current_user
    #changeset = Alert.changeset(%Alert{user_id = current_user.id}, alert_params)
    case Notification.create_alert(alert_params) do
      {:ok, alert} ->
        Email.price_alert_setup_email(conn.assigns.current_user.email, alert_params) |> Mailer.deliver_later()
        conn
        |> put_flash(:info, "Alert created successfully.")
        |> redirect(to: alert_path(conn, :show, alert))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    alert = Notification.get_alert!(id)
    render(conn, "show.html", alert: alert)
  end

  def edit(conn, %{"id" => id}) do
    alert = Notification.get_alert!(id)
    changeset = Notification.change_alert(alert)
    render(conn, "edit.html", alert: alert, changeset: changeset)
  end

  def update(conn, %{"id" => id, "alert" => alert_params}) do
    alert = Notification.get_alert!(id)

    case Notification.update_alert(alert, alert_params) do
      {:ok, alert} ->
        conn
        |> put_flash(:info, "Alert updated successfully.")
        |> redirect(to: alert_path(conn, :show, alert))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", alert: alert, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    alert = Notification.get_alert!(id)
    {:ok, _alert} = Notification.delete_alert(alert)

    conn
    |> put_flash(:info, "Alert deleted successfully.")
    |> redirect(to: alert_path(conn, :index))
  end
end
