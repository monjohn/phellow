# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

[
  %{title: "In Progress", id: 2, position: 1},
  %{title: "Upcoming", id: 1, position: 0},
  %{title: "Done", id: 3, position: 2}
]
|> Enum.each(fn params -> Phellow.Repo.insert!(params) end)
