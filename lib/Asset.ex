defmodule ThingsBoardIOT.Asset do
  alias HTTPoison
  alias ThingsBoardIOT.{Auth, Tenant, Asset, Customer, Device, DeviceProfile, GlobalVariables, TenantProfile, User}
  require Logger

  @doc """
    map = %{
    "tenantId"=> %{
        "id"=> "784f394c-42b6-435a-983c-b7beff2784f9",
        "entityType"=> "TENANT"
    },
    "name"=> "TENANT TEST 2",
    "type"=> "Building",
    "label"=> "NY Building",
    "additionalInfo"=> %{}
  }

    Asset.create("tenant@thingsboard.org", "tenant", map)
  """
  def create(username, password, map) do
    url = "#{ThingsBoardIOT.GlobalVariables.endPoint()}/asset"
    token = ThingsBoardIOT.Auth.requestToken(username, password)["token"]
    headerAuth = ThingsBoardIOT.GlobalVariables.headersAuth(token)
    json_body = Poison.encode!(map)

    {:ok, rep} =
      HTTPoison.request(%HTTPoison.Request{
        method: :post,
        url: url,
        body: json_body,
        headers: headerAuth
      })

    Poison.decode!(rep.body)
  end

  def list(username, password) do
    url = "#{ThingsBoardIOT.GlobalVariables.endPoint()}/tenant/assets?pageSize=10&page=0&sortOrder=ASC"
    token = ThingsBoardIOT.Auth.requestToken(username, password)["token"]
    headerAuth = ThingsBoardIOT.GlobalVariables.headersAuth(token)
    json_body = Poison.encode!(%{})

    {:ok, rep} =
      HTTPoison.request(%HTTPoison.Request{
        method: :get,
        url: url,
        body: json_body,
        headers: headerAuth
      })

    Poison.decode!(rep.body)["data"]
  end



end
