defmodule DonezoWeb.ListLive.FormComponent do
  use DonezoWeb, :live_component

  alias Donezo.Lists

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage list records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="list-form"
        phx-target={@myself}
        phx-submit="save"
      >
        <.input
          field={@form[:title]}
          type="text"
          label="Title"
          phx-debounce="blur"
          phx-target={@myself}
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save List</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{list: list} = assigns, socket) do
    changeset = Lists.change_list(list)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:form, to_form(changeset))}
  end

  @impl true
  def handle_event("validate", %{"list" => list_params}, socket) do
    changeset =
      socket.assigns.list
      |> Lists.change_list(list_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("save", %{"list" => list_params}, socket) do
    save_list(socket, socket.assigns.action, list_params)
  end

  defp save_list(socket, :edit, list_params) do
    case Lists.update_list(socket.assigns.list, list_params) do
      {:ok, list} ->
        notify_parent({:saved, list})

        {:noreply,
         socket
         |> put_flash(:info, "List updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp save_list(socket, :new, list_params) do
    list_params = Map.put(list_params, "user_id", socket.assigns.current_user.id)

    case Lists.create_list(list_params) do
      {:ok, list} ->
        notify_parent({:saved, list})

        {:noreply,
         socket
         |> put_flash(:info, "List created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
