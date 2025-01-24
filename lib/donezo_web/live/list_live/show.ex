defmodule DonezoWeb.ListLive.Show do
  use DonezoWeb, :live_view

  alias Donezo.Lists
  alias Donezo.Buzzes
  alias Donezo.Buzzes.Buzz

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :buzzes, [])}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    list = Lists.get_list!(id, socket.assigns.current_user.id)
    buzzes = Buzzes.list_buzzes_for_list(list)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:list, list)
     |> stream(:buzzes, buzzes)}
  end

  @impl true
  def handle_info({DonezoWeb.BuzzLive.FormComponent, {:saved, buzz}}, socket) do
    {:noreply, stream_insert(socket, :buzzes, buzz)}
  end

  @impl true
  def handle_event("toggle_completed", %{"id" => id}, socket) do
    buzz = Buzzes.get_buzz!(id)

    {:ok, updated_buzz} =
      Buzzes.update_buzz(buzz, %{
        completed: !buzz.completed,
        completed_at: if(!buzz.completed, do: DateTime.utc_now(), else: nil)
      })

    {:noreply, stream_insert(socket, :buzzes, updated_buzz)}
  end

  @impl true
  def handle_event("delete_buzz", %{"id" => id}, socket) do
    buzz = Buzzes.get_buzz!(id)
    {:ok, _} = Buzzes.delete_buzz(buzz)

    {:noreply, stream_delete(socket, :buzzes, buzz)}
  end

  defp page_title(:show), do: "Show List"
  defp page_title(:edit), do: "Edit List"
  defp page_title(:new_buzz), do: "New Buzz"
end
