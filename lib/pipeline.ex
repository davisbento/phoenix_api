defmodule PhoenixApi.Pipeline do
  use Guardian.Plug.Pipeline, otp_app: :phoenix_api,
                              module: PhoenixApi.Guardian,
                              error_handler: PhoenixApi.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
