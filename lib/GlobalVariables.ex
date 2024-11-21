defmodule ThingsBoardIOT.GlobalVariables do
  alias ThingsBoardIOT.{Auth, Tenant, Asset, Customer, Device, DeviceProfile, GlobalVariables, TenantProfile, User}

  @endpoint_key :thingsboard_endpoint

  def endPoint() do
    Application.get_env(:things_board_iot, @endpoint_key) || "https://things.tisalabs.com:443/api"
  end

  def initialize(endpoint_url) do
    Application.put_env(:things_board_iot, @endpoint_key, endpoint_url)
  end

  def headers() do
    [{"Content-type", "application/json"}]
  end

  def headersAuth(token) do
    [
      {"Content-type", "application/json"},
      {"Connection", "keep-alive"},
      {"Authorization", "Bearer #{token}"}
    ]
  end
end
