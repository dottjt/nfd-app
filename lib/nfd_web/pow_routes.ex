defmodule NfdWeb.Pow.Routes do
  use Pow.Phoenix.Routes
  alias NfdWeb.Router.Helpers, as: Routes

  def after_sign_out_path(conn), do: Routes.page_path(conn, :general_home)
  def after_sign_in_path(conn), do: Routes.dashboard_path(conn, :dashboard)
  def after_registration_path(conn), do: # Routes.page_path(conn, :confirm_email_begin)
    if Pow.Plug.current_user(conn),
      do: Routes.dashboard_path(conn, :dashboard),
      else: Routes.pow_session_path(conn, :new)

  # def user_not_authenticated_path(conn), do: Routes.pow_session_path(conn, :new)
  def after_user_deleted_path(conn), do: Routes.page_path(conn, :general_home)
end
