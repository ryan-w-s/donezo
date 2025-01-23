defmodule DonezoWeb.ListLive.Index do
  use DonezoWeb, :live_view

  alias Donezo.Lists
  alias Donezo.Lists.List

  @impl true
  def mount(_params, _session, socket) do
    lists = Lists.list_lists(socket.assigns.current_user)

    {:ok,
     socket
     |> assign(:page_title, "Listing Lists")
     |> stream(:lists, lists)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit List")
    |> assign(:list, Lists.get_list!(id, socket.assigns.current_user.id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New List")
    |> assign(:list, %List{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Lists")
    |> assign(:list, nil)
  end

  @impl true
  def handle_info({DonezoWeb.ListLive.FormComponent, {:saved, list}}, socket) do
    {:noreply,
     socket
     |> put_flash(:info, "List saved successfully")
     |> stream_insert(:lists, list)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    list = Lists.get_list!(id, socket.assigns.current_user.id)
    {:ok, _} = Lists.delete_list(list)

    {:noreply,
     socket
     |> put_flash(:info, "List deleted successfully")
     |> stream_delete(:lists, list)}
  end
end
