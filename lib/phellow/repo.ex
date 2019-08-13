defmodule Phellow.Repo do
  use Ecto.Repo,
    otp_app: :phellow,
    adapter: Ecto.Adapters.Postgres
end
