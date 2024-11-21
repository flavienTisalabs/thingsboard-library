defmodule ThingsBoardIOT.TenantProfile do
  alias HTTPoison
  alias ThingsBoardIOT.{Auth, Tenant, Asset, Customer, Device, DeviceProfile, GlobalVariables, TenantProfile, User}
  require Logger

  @doc """

    TenantProfile.create("sysadmin@thingsboard.org", "sysadmin", map)

    map = %{
    "name" => "TestProfile2",
    "description" => "Test tenant profile",
    "isolatedTbRuleEngine" => false,
    "profileData" => %{
      "configuration" => %{
        "type" => "DEFAULT",
        "maxDevices" => 0,
        "maxAssets" => 0,
        "maxCustomers" => 0,
        "maxUsers" => 0,
        "maxDashboards" => 0,
        "maxRuleChains" => 0,
        "maxResourcesInBytes" => 0,
        "maxOtaPackagesInBytes" => 0,
        "transportTenantMsgRateLimit" => nil,
        "transportTenantTelemetryMsgRateLimit" => nil,
        "transportTenantTelemetryDataPointsRateLimit" => nil,
        "transportDeviceMsgRateLimit" => nil,
        "transportDeviceTelemetryMsgRateLimit" => nil,
        "transportDeviceTelemetryDataPointsRateLimit" => nil,
        "tenantEntityExportRateLimit" => nil,
        "tenantEntityImportRateLimit" => nil,
        "maxTransportMessages" => 0,
        "maxTransportDataPoints" => 0,
        "maxREExecutions" => 0,
        "maxJSExecutions" => 0,
        "maxDPStorageDays" => 0,
        "maxRuleNodeExecutionsPerMessage" => 0,
        "maxEmails" => 0,
        "maxSms" => 0,
        "maxCreatedAlarms" => 0,
        "tenantServerRestLimitsConfiguration" => nil,
        "customerServerRestLimitsConfiguration" => nil,
        "maxWsSessionsPerTenant" => 0,
        "maxWsSessionsPerCustomer" => 0,
        "maxWsSessionsPerRegularUser" => 0,
        "maxWsSessionsPerPublicUser" => 0,
        "wsMsgQueueLimitPerSession" => 0,
        "maxWsSubscriptionsPerTenant" => 0,
        "maxWsSubscriptionsPerCustomer" => 0,
        "maxWsSubscriptionsPerRegularUser" => 0,
        "maxWsSubscriptionsPerPublicUser" => 0,
        "wsUpdatesPerSessionRateLimit" => nil,
        "cassandraQueryTenantRateLimitsConfiguration" => nil,
        "defaultStorageTtlDays" => 0,
        "alarmsTtlDays" => 0,
        "rpcTtlDays" => 0,
        "warnThreshold" => 0
      },
      "queueConfiguration" => nil
    },
    "default" => false
  }
"""

  def create(username, password, map) do
    url = "#{ThingsBoardIOT.GlobalVariables.endPoint()}/tenantProfile"
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

  def getDefaultProfile(username, password) do
    url = "#{ThingsBoardIOT.GlobalVariables.endPoint()}/tenantProfileInfo/default"
    token = ThingsBoardIOT.Auth.requestToken(username, password)["token"]
    headerAuth = ThingsBoardIOT.GlobalVariables.headersAuth(token)

    { :ok, rep} =
      HTTPoison.request(%HTTPoison.Request{method: :get, url: url, body: [], headers: headerAuth})

    Poison.decode!(rep.body)
  end
end
