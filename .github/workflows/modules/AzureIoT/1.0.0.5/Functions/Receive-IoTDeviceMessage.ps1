function Receive-IoTDeviceMessage {
  <#
      .SYNOPSIS
      Receives a message from the device to cloud.
      .DESCRIPTION
      See the Synopsis.
      .EXAMPLE
      $message = Receive-IoTDeviceMessage -iotConnString "HostName=myIotHub.azure-devices.net;SharedAccessKeyName=iothubowner;SharedAccessKey=HwbPu8ZhKsdfgdgdsgdfg1cxmbHh7w1QM2KvRE="
  #>
  [cmdletbinding()]
  param(
    $iotConnString
  )
  $eventHubClient = [Microsoft.ServiceBus.Messaging.EventHubClient]::CreateFromConnectionString($iotConnString, "messages/events")
  $iotConnString=  $AzureIoTConnectionString
  $eventHubPartitions = $eventHubClient.GetRuntimeInformation().PartitionIds
    $partition = 1
  #foreach ($partition in $eventHubPartitions[1]) {
    $eventHubReceiver = $eventHubClient.GetDefaultConsumerGroup().CreateReceiver($partition, [DateTime]::UtcNow)
    
    while ($true) {

      $asyncOperation = $eventHubReceiver.ReceiveAsync()
      $eventData = $asyncOperation.Wait()
      $eventData
      if($null -eq $eventData) { throw "No Event data, queue empty?" }
      $message = [System.Text.Encoding]::UTF8.GetString($eventData.GetBytes())
      $message.SystemProperties
      Start-Sleep -Milliseconds 50
    }
 # }
}