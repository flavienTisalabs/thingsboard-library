defmodule ThingsBoardIOT.Auth do
  alias ThingsBoardIOT.{Auth, Tenant, Asset, Customer, Device, DeviceProfile, GlobalVariables, TenantProfile, User}
  alias HTTPoison
  require Logger

  @headers [{"Content-type", "application/json"}]

  @moduledoc """
    Reference https://demo.thingsboard.io/swagger-ui/#/login-endpoint
  """

  @doc """
    Login method used to authenticate user and get JWT token data.
    iex> Auth.requestToken(username, password, endpoint)
  """

  def requestToken(username, password) do
    url = "#{ThingsBoardIOT.GlobalVariables.endPoint()}/auth/login"

    body =
      Poison.encode!(%{
        username: username,
        password: password
      })

    {_status, rep} = HTTPoison.post(url, body, ThingsBoardIOT.GlobalVariables.headers())
    Poison.decode!(rep.body)
  end

  def get_auth_url do
    "#{ThingsBoardIOT.GlobalVariables.endPoint()}/auth/login"
  end

  def requestToken_status_code(username, password) do
    url = "#{ThingsBoardIOT.GlobalVariables.endPoint()}/auth/login"

    body =
      Poison.encode!(%{
        username: username,
        password: password
      })

    {_status, rep} = HTTPoison.post(url, body, ThingsBoardIOT.GlobalVariables.headers())
    {rep.status_code, Poison.decode!(rep.body)}
  end

end
