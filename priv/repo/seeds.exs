# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#

import Ecto.Query, warn: false
alias Phellow.Content
alias Phellow.Content.{Board, List}
alias Phellow.Repo

title = "Things To Be Done"

Content.create_board(%{
  title: title,
  img_url:
    "https://www.israel21c.org/wp-content/uploads/2018/07/israel-sunset-ashkelon-september.jpg"
})

query =
  Ecto.Query.from(b in Board,
    where: b.title == ^title,
    limit: 1
  )

board = Repo.one(query)

[
  %List{title: "In Progress", board_id: board.id, position: 1},
  %List{title: "Upcoming", board_id: board.id, position: 0},
  %List{title: "Done", board_id: board.id, position: 2}
]
|> Enum.each(fn params -> Repo.insert!(params) end)
