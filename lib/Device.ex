defmodule ThingsBoardIOT.Device do
  alias HTTPoison
  alias ThingsBoardIOT.{Auth, Tenant, Asset, Customer, Device, DeviceProfile, GlobalVariables, TenantProfile, User}
  require Logger

  @doc """
    map = %{
      "tenantId" => %{
        "id" => "784f394c-42b6-435a-983c-b7beff2784f9",
        "entityType" => "TENANT"
      },
      "name" => "test_device",
      "type" => "Temperature Sensor",
      "label" => "Room 234 Sensor",
      "deviceProfileId" => %{
        "id" => "53899500-38f2-11ed-8fd3-4b092658b38b",
        "entityType" => "DEVICE_PROFILE"
      }
    }

    Device.create("tenant@thingsboard.org", "tenant", map)
  """
  def create(username, password, map) do
    url = "#{ThingsBoardIOT.GlobalVariables.endPoint()}/device"
    token = ThingsBoardIOT.Auth.requestToken(username, password)["token"]
    headerAuth = ThingsBoardIOT.GlobalVariables.headersAuth(token)
    json_body = Poison.encode!(map)

    {:ok, rep} =
      HTTPoison.request(%HTTPoison.Request{
        method: :post,
        url: url,
        body: json_body,
        headers: headerAuth,
        params: %{accessToken: token}
      })

    Poison.decode!(rep.body)
  end

  def create_with_creds(username, password, map) do
    url = "#{ThingsBoardIOT.GlobalVariables.endPoint()}/device-with-credentials"
    token = ThingsBoardIOT.Auth.requestToken(username, password)["token"]
    headerAuth = ThingsBoardIOT.GlobalVariables.headersAuth(token)
    json_body = Poison.encode!(map)

    {:ok, rep} =
      HTTPoison.request(%HTTPoison.Request{
        method: :post,
        url: url,
        body: json_body,
        headers: headerAuth,
        params: %{accessToken: token}
      })

    Poison.decode!(rep.body)
  end

  def get_device_credentials(username, password, device_id) do
    url = "#{ThingsBoardIOT.GlobalVariables.endPoint()}/device/#{device_id}/credentials"
    token = ThingsBoardIOT.Auth.requestToken(username, password)["token"]
    headerAuth = ThingsBoardIOT.GlobalVariables.headersAuth(token)
    HTTPoison.request(%HTTPoison.Request{
      method: :get,
      url: url,
      headers: headerAuth,
      params: %{accessToken: token}
    })
  end

  def delete(username, password, device_id) do
    url = "#{ThingsBoardIOT.GlobalVariables.endPoint()}/device/#{device_id}"
    token = ThingsBoardIOT.Auth.requestToken(username, password)["token"]
    headerAuth = ThingsBoardIOT.GlobalVariables.headersAuth(token)
    json_body = Poison.encode!(%{})

    {:ok, resp} = HTTPoison.request(%HTTPoison.Request{
      method: :delete,
      url: url,
      body: json_body,
      headers: headerAuth,
      params: %{accessToken: token}
    })

    {resp, resp.status_code}
  end

end
