defmodule PhoenixApi.Email do
  use Bamboo.Phoenix, view: PhoenixApiWeb.EmailView

  def welcome_email(user) do
    base_email()
    |> to(user.email)
    |> subject("Welcome to MyApp. I'll be your guide")
    |> assign(:user, user)
    |> render("welcome_new_user.html")
  end

  defp base_email() do
    new_email()
    |> from("hello@myapp.io")
    |> put_html_layout({PhoenixApiWeb.LayoutView, "email.html"})
  end
end
