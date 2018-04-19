# Attribution: Sending Email in Elixir with BAmboo Part 1
# Link: https://www.youtube.com/watch?v=tHfGXnrvksQ

defmodule Cryptotracker.Email do
    import Bamboo.Email

    def price_alert_email do
        new_email(
            from: "henryzhou95@gmail.com",
            to: "henryzhou95@gmail.com",
            subject: "Testing email",
            text_body: "1 2 3 ",
            html_body: "<p>poo</p>"
        )
    end
end