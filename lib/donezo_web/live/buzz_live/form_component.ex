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
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:completed]} type="checkbox" label="Completed" />
        <.input field={@form[:completed_at]} type="datetime-local" label="Completed at" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Buzz</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{buzz: buzz} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Buzzes.change_buzz(buzz))
     end)}
  end

  @impl true
  def handle_event("validate", %{"buzz" => buzz_params}, socket) do
    changeset = Buzzes.change_buzz(socket.assigns.buzz, buzz_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
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
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_buzz(socket, :new, buzz_params) do
    case Buzzes.create_buzz(buzz_params) do
      {:ok, buzz} ->
        notify_parent({:saved, buzz})

        {:noreply,
         socket
         |> put_flash(:info, "Buzz created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
