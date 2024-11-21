defmodule ThingsBoardIOT.Mqtt do
  alias HTTPoison
  alias ThingsBoardIOT.{Auth, GlobalVariables}
  require Logger

  def send_mqtt_msg(username, client_id, host, port, topic, message) do
    {:ok, _pid} = Tortoise.Supervisor.start_child(
      client_id: client_id,
      handler: {Tortoise.Handler.Logger, []},
      server: {Tortoise.Transport.Tcp, host: host, port: port},
      user_name: username)
    new_message = "{\"message #{client_id}\": #{message}}"
    Tortoise.publish(client_id, topic, new_message)
  end
end
