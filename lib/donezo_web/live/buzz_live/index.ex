defmodule DonezoWeb.BuzzLive.Index do
  use DonezoWeb, :live_view

  alias Donezo.Buzzes
  alias Donezo.Buzzes.Buzz

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :buzzes, Buzzes.list_buzzes())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Buzz")
    |> assign(:buzz, Buzzes.get_buzz!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Buzz")
    |> assign(:buzz, %Buzz{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Buzzes")
    |> assign(:buzz, nil)
  end

  @impl true
  def handle_info({DonezoWeb.BuzzLive.FormComponent, {:saved, buzz}}, socket) do
    {:noreply, stream_insert(socket, :buzzes, buzz)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    buzz = Buzzes.get_buzz!(id)
    {:ok, _} = Buzzes.delete_buzz(buzz)

    {:noreply, stream_delete(socket, :buzzes, buzz)}
  end
end
