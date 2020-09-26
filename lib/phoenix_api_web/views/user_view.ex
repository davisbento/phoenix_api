defmodule PhoenixApiWeb.UserView do
  use PhoenixApiWeb, :view
  alias PhoenixApiWeb.UserView

  def render("index.json", %{users: users}) do
    render_many(users, UserView, "user.json")
  end

  def render("show.json", %{user: user}) do
    render_one(user, UserView, "user.json")
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email,
      is_active: user.is_active}
  end

  def render("sign_in.json", %{token: token}) do
    %{token: token}
  end
end
