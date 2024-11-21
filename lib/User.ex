defmodule ThingsBoardIOT.User do
  alias HTTPoison
  alias ThingsBoardIOT.{Auth, Tenant, Asset, Customer, Device, DeviceProfile, GlobalVariables, TenantProfile, User}
  require Logger

  def create(username, password, map) do
    url = "#{ThingsBoardIOT.GlobalVariables.endPoint()}/user?sendActivationMail=true"
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

    rep = Poison.decode!(rep.body)

    case rep["status"] == 400 do
      true ->
        {:error, rep["message"], rep}
      false ->
        {:ok, rep}
    end
  end

  def get_user_by_id(username, password, id) do
    id = URI.encode_www_form(id)
    url = "#{ThingsBoardIOT.GlobalVariables.endPoint()}/user/#{id}"
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

    Poison.decode!(rep.body)
  end

  def get_user_by_tenant_id(username, password, tenant_id, email) do
    email = URI.encode_www_form(email)
    tenant_id = URI.encode_www_form(tenant_id)
    url = "#{ThingsBoardIOT.GlobalVariables.endPoint()}/tenant/#{tenant_id}/users?pageSize=10&page=0&textSearch=#{email}&sortProperty=email&sortOrder=ASC"

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
    case rep["totalPages"] do
      0 ->
        {:error, "User does not exists.", rep["data"]}
      _ ->
        {:ok, rep["data"]}
    end
  end


  def getTenantAdminsByTenantId(username, password, tenant_id) do
    Logger.warn("TENANT ID #{inspect tenant_id}")
    tenant_id = URI.encode_www_form(tenant_id)
    url = "#{ThingsBoardIOT.GlobalVariables.endPoint()}/tenant/#{tenant_id}/users?pageSize=10&page=0"


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
    case length(rep["data"]) != 0 do
      true ->
        {:ok, rep["data"]}
      false ->
        {:error, rep["data"]}
    end
  end
end
