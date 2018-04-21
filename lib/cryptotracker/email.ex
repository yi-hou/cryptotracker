# Attribution: Sending Email in Elixir with BAmboo Part 1
# Link: https://www.youtube.com/watch?v=tHfGXnrvksQ

defmodule Cryptotracker.Email do
    import Bamboo.Email

    def price_alert_setup_email(user_email, alert_params) do
        new_email(
            from: "henryzhou95@gmail.com",
            to: user_email,
            subject: "Your Cryptotracker Alert has been set",
            text_body: "Your Cryptotracker Alert for #{alert_params["symbol"]} at $#{alert_params["price"]} has been successfully set.",
        )
    end
end