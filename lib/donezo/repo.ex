defmodule Donezo.Repo do
  use Ecto.Repo,
    otp_app: :donezo,
    adapter: Ecto.Adapters.SQLite3
end
