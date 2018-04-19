defmodule Cryptotracker.NotificationTest do
  use Cryptotracker.DataCase

  alias Cryptotracker.Notification

  describe "alerts" do
    alias Cryptotracker.Notification.Alert

    @valid_attrs %{lowAlert: true, price: 120.5, symbol: "some symbol"}
    @update_attrs %{lowAlert: false, price: 456.7, symbol: "some updated symbol"}
    @invalid_attrs %{lowAlert: nil, price: nil, symbol: nil}

    def alert_fixture(attrs \\ %{}) do
      {:ok, alert} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Notification.create_alert()

      alert
    end

    test "list_alerts/0 returns all alerts" do
      alert = alert_fixture()
      assert Notification.list_alerts() == [alert]
    end

    test "get_alert!/1 returns the alert with given id" do
      alert = alert_fixture()
      assert Notification.get_alert!(alert.id) == alert
    end

    test "create_alert/1 with valid data creates a alert" do
      assert {:ok, %Alert{} = alert} = Notification.create_alert(@valid_attrs)
      assert alert.lowAlert == true
      assert alert.price == 120.5
      assert alert.symbol == "some symbol"
    end

    test "create_alert/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Notification.create_alert(@invalid_attrs)
    end

    test "update_alert/2 with valid data updates the alert" do
      alert = alert_fixture()
      assert {:ok, alert} = Notification.update_alert(alert, @update_attrs)
      assert %Alert{} = alert
      assert alert.lowAlert == false
      assert alert.price == 456.7
      assert alert.symbol == "some updated symbol"
    end

    test "update_alert/2 with invalid data returns error changeset" do
      alert = alert_fixture()
      assert {:error, %Ecto.Changeset{}} = Notification.update_alert(alert, @invalid_attrs)
      assert alert == Notification.get_alert!(alert.id)
    end

    test "delete_alert/1 deletes the alert" do
      alert = alert_fixture()
      assert {:ok, %Alert{}} = Notification.delete_alert(alert)
      assert_raise Ecto.NoResultsError, fn -> Notification.get_alert!(alert.id) end
    end

    test "change_alert/1 returns a alert changeset" do
      alert = alert_fixture()
      assert %Ecto.Changeset{} = Notification.change_alert(alert)
    end
  end
end
