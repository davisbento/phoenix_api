defmodule PhoenixApiWeb.AuthController do
  use PhoenixApiWeb, :controller

  alias PhoenixApi.Auth
  alias PhoenixApi.Mailer
  alias PhoenixApi.Email
  alias PhoenixApi.Auth.User

  action_fallback PhoenixApiWeb.FallbackController

  def sign_up(conn, %{"user" => user_params}) do
    case Auth.create_user(user_params) do
      {:ok, %User{} = user} ->
        user
        |> Email.welcome_email()
        |> Mailer.deliver_later()

        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.user_path(conn, :show, user))
        |> render("show.json", user: user)

      {:error, _changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(PhoenixApiWeb.ErrorView)
        |> render("422.json", message: "Invalid fields")
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Auth.authenticate_user(email, password) do
      {:ok, user} ->
        {:ok, token, _claims} = PhoenixApi.Guardian.encode_and_sign(user)

        conn
        |> put_status(:ok)
        |> put_view(PhoenixApiWeb.UserView)
        |> render("sign_in.json", token: token)

      {:error, reason} ->
        conn
        |> put_status(:unauthorized)
        |> put_view(PhoenixApiWeb.ErrorView)
        |> render("401.json", message: reason)
    end
  end
end
