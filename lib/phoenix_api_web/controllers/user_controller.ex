defmodule PhoenixApiWeb.UserController do
  use PhoenixApiWeb, :controller

  alias PhoenixApi.Auth
  alias PhoenixApi.Auth.User

  action_fallback PhoenixApiWeb.FallbackController

  def index(conn, _params) do
    users = Auth.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    case Auth.create_user(user_params) do
      {:ok, %User{} = user} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.user_path(conn, :show, user))
        |> render("show.json", user: user)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(PhoenixApiWeb.ErrorView)
        |> render("422.json", message: "Invalid fields")
    end
  end

  def show(conn, %{"id" => id}) do
    user = Auth.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Auth.get_user!(id)

    with {:ok, %User{} = user} <- Auth.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Auth.get_user!(id)

    with {:ok, %User{}} <- Auth.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Auth.authenticate_user(email, password) do
      {:ok, token} ->
        conn
        |> put_status(:ok)
        |> put_view(PhoenixApiWeb.UserView)
        |> render("sign_in.json", token: token)

      {:error, message} ->
        conn
        |> put_status(:unauthorized)
        |> put_view(PhoenixApiWeb.ErrorView)
        |> render("401.json", message: message)
    end
  end
end
