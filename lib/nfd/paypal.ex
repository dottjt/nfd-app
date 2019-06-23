defmodule Nfd.Paypal do
  
  alias Nfd.Account
  alias Nfd.Content

  alias Nfd.EmailLogs

  # https://developer.paypal.com/docs/checkout/integrate/

  def payment_process(conn, user, collection) do
    case Account.create_collection_access(%{user_id: user.id, collection_id: collection.id}) do
      {:ok, collection_access} ->
        EmailLogs.success_payment_email_log("#{user.email} - $#{collection.price} - #{collection.display_name}")
        conn |> Plug.Conn.send_resp(200, "Payment Successful")
      {:error, error} -> 
        EmailLogs.failure_payment_email_log("#{user.email} - $#{collection.price} - #{collection.display_name}")
        conn |> Plug.Conn.send_resp(403, "Payment Unsuccessful")
      end
  end

  def create_paypal_session(user, host, collection_slug) do 
    case PayPal.API.get_oauth_token() do 
      {:ok, { token, expires }} -> token
      {:error, error} -> error
    end
  end

  def get_api_key(host) do 
    if host == "localhost" do 
      System.get_env("PAYPAL_API_TEST_KEY")
    else 
      System.get_env("PAYPAL_API_KEY")
    end
  end

end
