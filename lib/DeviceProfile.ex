defmodule ThingsBoardIOT.DeviceProfile do
  alias HTTPoison
  alias ThingsBoardIOT.{Auth, Tenant, Asset, Customer, Device, DeviceProfile, GlobalVariables, TenantProfile, User}
  require Logger

  @doc """
    map = %{
        "createdTime" => 1609459200000,
        "tenantId" => %{
          "id" => "784f394c-42b6-435a-983c-b7beff2784f9",
          "entityType" => "TENANT"
        },
        "name" => "TEST_DEVICE_PROFILE",
        "default" => false,
        "defaultDashboardId" => %{
          "id" => "784f394c-42b6-435a-983c-b7beff2784f9",
          "entityType" => "DASHBOARD"
        },
        "defaultRuleChainId" => %{
          "id" => "784f394c-42b6-435a-983c-b7beff2784f9",
          "entityType" => "RULE_CHAIN"
        },
        "defaultQueueName" => "string",
        "firmwareId" => %{
          "id" => "784f394c-42b6-435a-983c-b7beff2784f9",
          "entityType" => "OTA_PACKAGE"
        },
        "softwareId" => %{
          "id" => "784f394c-42b6-435a-983c-b7beff2784f9",
          "entityType" => "OTA_PACKAGE"
        },
        "description" => "string",
        "image" => "string",
        "provisionDeviceKey" => "string",
        "transportType" => "COAP",
        "provisionType" => "ALLOW_CREATE_NEW_DEVICES",
        "profileData" => %{
          "configuration" => %{},
          "transportConfiguration" => %{},
          "provisionConfiguration" => %{
            "provisionDeviceSecret" => "string"
          },
          "alarms" => [
            %{
              "id" => "highTemperatureAlarmID",
              "alarmType" => "High Temperature Alarm",
              "createRules" => %{
                "additionalProp1" => %{
                  "condition" => %{
                    "condition" => [
                      %{
                        "key" => %{
                          "type" => "TIME_SERIES",
                          "key" => "temp"
                        },
                        "valueType" => "NUMERIC",
                        "value" => %{},
                        "predicate" => %{}
                      }
                    ],
                    "spec" => %{}
                  },
                  "schedule" => %{
                    "dynamicValue" => %{
                      "inherit" => true,
                      "sourceAttribute" => "string",
                      "sourceType" => "CURRENT_CUSTOMER"
                    },
                    "type" => "ANY_TIME"
                  },
                  "alarmDetails" => "string",
                  "dashboardId" => %{
                    "id" => "784f394c-42b6-435a-983c-b7beff2784f9",
                    "entityType" => "DASHBOARD"
                  }
                },
                "additionalProp2" => %{
                  "condition" => %{
                    "condition" => [
                      %{
                        "key" => %{
                          "type" => "TIME_SERIES",
                          "key" => "temp"
                        },
                        "valueType" => "NUMERIC",
                        "value" => %{},
                        "predicate" => %{}
                      }
                    ],
                    "spec" => %{}
                  },
                  "schedule" => %{
                    "dynamicValue" => %{
                      "inherit" => true,
                      "sourceAttribute" => "string",
                      "sourceType" => "CURRENT_CUSTOMER"
                    },
                    "type" => "ANY_TIME"
                  },
                  "alarmDetails" => "string",
                  "dashboardId" => %{
                    "id" => "784f394c-42b6-435a-983c-b7beff2784f9",
                    "entityType" => "DASHBOARD"
                  }
                },
                "additionalProp3" => %{
                  "condition" => %{
                    "condition" => [
                      %{
                        "key" => %{
                          "type" => "TIME_SERIES",
                          "key" => "temp"
                        },
                        "valueType" => "NUMERIC",
                        "value" => %{},
                        "predicate" => %{}
                      }
                    ],
                    "spec" => %{}
                  },
                  "schedule" => %{
                    "dynamicValue" => %{
                      "inherit" => true,
                      "sourceAttribute" => "string",
                      "sourceType" => "CURRENT_CUSTOMER"
                    },
                    "type" => "ANY_TIME"
                  },
                  "alarmDetails" => "string",
                  "dashboardId" => %{
                    "id" => "784f394c-42b6-435a-983c-b7beff2784f9",
                    "entityType" => "DASHBOARD"
                  }
                }
              },
              "clearRule" => %{
                "condition" => %{
                  "condition" => [
                    %{
                      "key" => %{
                        "type" => "TIME_SERIES",
                        "key" => "temp"
                      },
                      "valueType" => "NUMERIC",
                      "value" => %{},
                      "predicate" => %{}
                    }
                  ],
                  "spec" => %{}
                },
                "schedule" => %{
                  "dynamicValue" => %{
                    "inherit" => true,
                    "sourceAttribute" => "string",
                    "sourceType" => "CURRENT_CUSTOMER"
                  },
                  "type" => "ANY_TIME"
                },
                "alarmDetails" => "string",
                "dashboardId" => %{
                  "id" => "784f394c-42b6-435a-983c-b7beff2784f9",
                  "entityType" => "DASHBOARD"
                }
              },
              "propagate" => true,
              "propagateToOwner" => true,
              "propagateToTenant" => true,
              "propagateRelationTypes" => [
                "string"
              ]
            }
          ]
        },
        "type" => "DEFAULT"
      }

      DeviceProfile.create("tenant@thingsboard.org", "tenant", map)
  """
  def create(username, password, map) do
    url = "#{ThingsBoardIOT.GlobalVariables.endPoint()}/deviceProfile"
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
    url = "#{ThingsBoardIOT.GlobalVariables.endPoint()}/deviceProfileInfo/default"
    token = ThingsBoardIOT.Auth.requestToken(username, password)["token"]
    headerAuth = ThingsBoardIOT.GlobalVariables.headersAuth(token)

    {:ok, rep} =
      HTTPoison.request(%HTTPoison.Request{method: :get, url: url, body: [], headers: headerAuth})

    Poison.decode!(rep.body)
  end
end
