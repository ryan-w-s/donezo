defmodule Donezo.Repo do
  use Ecto.Repo,
    otp_app: :donezo,
    adapter: Ecto.Adapters.Postgres
end
