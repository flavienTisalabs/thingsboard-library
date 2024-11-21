defmodule ThingsBoardIOT.Tenant do
  alias HTTPoison
  alias ThingsBoardIOT.{Auth, Tenant, Asset, Customer, Device, DeviceProfile, GlobalVariables, TenantProfile, User}
  require Logger

  @doc """
    map = %{
      "title"=> "tisalabs2",
      "region"=> "North America",
      "tenantProfileId"=> %{
          "id"=> "4ee7d250-38f2-11ed-8fd3-4b092658b38b",
          "entityType"=> "TENANT_PROFILE"
      },
      "country"=> "US",
      "state"=> "NY",
      "city"=> "New York",
      "address"=> "42 Broadway Suite 12-400",
      "address2"=> "string",
      "zip"=> "10004",
      "phone"=> "+1(415)777-7777",
      "email"=> "example@company.com",
      "additionalInfo"=> %{}
    }
  """
  def create(username, password, map) do
    title = URI.encode_www_form(map["title"])
    url = "#{ThingsBoardIOT.GlobalVariables.endPoint()}/tenants?pageSize=1&page=0&textSearch=#{title}&sortProperty=title"
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

      rep = Poison.decode!(rep.body)

      if rep["totalPages"] == 0 do
        url = "#{ThingsBoardIOT.GlobalVariables.endPoint()}/tenant"
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
      {:ok, Poison.decode!(rep.body)}
    else
      {:error, rep}
    end
  end
end
