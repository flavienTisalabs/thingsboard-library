defmodule ThingsBoardIOT.Customer do
  alias HTTPoison
  alias ThingsBoardIOT.{Auth, Tenant, Asset, Customer, Device, DeviceProfile, GlobalVariables, TenantProfile, User}
  require Logger

  def create(username, password, map) do
    url = "#{ThingsBoardIOT.GlobalVariables.endPoint()}/customer"
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
    url = "#{ThingsBoardIOT.GlobalVariables.endPoint()}/customers?pageSize=10&page=0&sortOrder=ASC"
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

  def assignAsset(username, password, customerId, assetId) do
    customerId = URI.encode_www_form(customerId)
    assetId = URI.encode_www_form(assetId)
    url = "#{ThingsBoardIOT.GlobalVariables.endPoint()}/customer/#{customerId}/asset/#{assetId}"
    token = ThingsBoardIOT.Auth.requestToken(username, password)["token"]
    headerAuth = ThingsBoardIOT.GlobalVariables.headersAuth(token)
    json_body = Poison.encode!(%{})

    {:ok, rep} =
      HTTPoison.request(%HTTPoison.Request{
        method: :post,
        url: url,
        body: json_body,
        headers: headerAuth
      })

    Poison.decode!(rep.body)
  end

end
