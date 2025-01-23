defmodule DonezoWeb.BuzzLive.Show do
  use DonezoWeb, :live_view

  alias Donezo.Buzzes

  @impl true
  def mount(%{"list_id" => list_id}, _session, socket) do
    {:ok, assign(socket, :list_id, list_id)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:buzz, Buzzes.get_buzz!(id))}
  end

  defp page_title(:show), do: "Show Buzz"
  defp page_title(:edit), do: "Edit Buzz"
end
