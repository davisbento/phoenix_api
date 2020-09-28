defmodule PhoenixApiWeb.AuthView do
  use PhoenixApiWeb, :view
  alias PhoenixApiWeb.AuthView

  def render("show.json", %{user: user}) do
    %{id: user.id,
      email: user.email,
      is_active: user.is_active}
  end

  def render("sign_in.json", %{token: token}) do
    %{token: token}
  end
end
