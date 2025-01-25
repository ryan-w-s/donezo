defmodule DonezoWeb.BuzzLive.FormComponent do
  use DonezoWeb, :live_component

  alias Donezo.Buzzes

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage buzz records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="buzz-form"
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
          <.button phx-disable-with="Saving...">Save Buzz</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{buzz: buzz} = assigns, socket) do
    changeset = Buzzes.change_buzz(buzz)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:form, to_form(changeset))}
  end

  @impl true
  def handle_event("validate", %{"buzz" => buzz_params}, socket) do
    changeset =
      socket.assigns.buzz
      |> Buzzes.change_buzz(buzz_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("save", %{"buzz" => buzz_params}, socket) do
    save_buzz(socket, socket.assigns.action, buzz_params)
  end

  defp save_buzz(socket, :edit, buzz_params) do
    case Buzzes.update_buzz(socket.assigns.buzz, buzz_params) do
      {:ok, buzz} ->
        notify_parent({:saved, buzz})

        {:noreply,
         socket
         |> put_flash(:info, "Buzz updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp save_buzz(socket, :new, buzz_params) do
    buzz_params = buzz_params
      |> Map.put("list_id", socket.assigns.list_id)
      |> Map.put("user_id", socket.assigns.current_user.id)

    case Buzzes.create_buzz(buzz_params) do
      {:ok, buzz} ->
        notify_parent({:saved, buzz})

        {:noreply,
         socket
         |> put_flash(:info, "Buzz created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
