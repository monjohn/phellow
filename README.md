[![Generic badge](https://img.shields.io/circleci/build/github/monjohn/phellow.svg)](https://shields.io/)

# Phellow

## A Trello Clone in Phoenix using LiveView

![Phellow demonstration](/assets/static/images/Phello-demonstration.gif)

Phoenix LiveView is awesome. I wrote a basic Trello clone with less than 100 lines of Javascript. The logic in Elixir is a bit over 200 lines (see `lib/phellow_web/live/boards_live.ex`).

This project is for testing and learning, hopefully it could be a reference for others who are exploring the same ideas, notably LiveView, Phoenix PubSub, and Ecto. I would also appreciate it greatly if anyone has feedback on the code that I have written on ways that it could be improved.

To run locally:

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Install Node.js dependencies with `cd assets && npm install`
- Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
