defmodule Trackers.Repo do
  use Ecto.Repo,
    otp_app: :trackers,
    adapter: Ecto.Adapters.Postgres
end
