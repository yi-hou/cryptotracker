# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Cryptotracker.Repo.insert!(%Cryptotracker.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule Seeds do
  alias TaskTracker3.Repo
  alias TaskTracker3.Users.User
  alias TaskTracker3.Tasks.Task

  def run do
    p = Comeonin.Argon2.hashpwsalt("password1")

    Repo.delete_all(User)
    a = Repo.insert!(%User{ email: "lee@gmail.com", firstname: "steve", lastname: "Lee",
    password: "password1", password_confirmation: "password1",password_hash: p })
    b = Repo.insert!(%User{ email: "smith@gmail.com", firstname: "alice", lastname: "smith",
    password: "password1", password_confirmation: "password1",password_hash: p })
    c = Repo.insert!(%User{ email: "hou@gmail.com", firstname: "yi", lastname: "hou",
    password: "password1", password_confirmation: "password1",password_hash: p })
    d = Repo.insert!(%User{ email: "duff@gmail.com", firstname: "daniel", lastname: "duff",
    password: "password1", password_confirmation: "password1",password_hash: p })


 end
end

Seeds.run
