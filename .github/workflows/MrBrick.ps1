$iotConnString  = "${{secrets.IOTCONNECTIONSTRING}}"
$deviceId = "MrBrick"

Import-Module ".\.github\workflows\dll\Microsoft.Azure.Devices.dll" -Verbose

$stringArray = $()
$added_files = ${{ steps.changed-files.outputs.all_changed_files }} 
$added_files
$stringArray += ${{ steps.changed-files.outputs.all_changed_files }} 
$stringArray.count
$content = Get-Content -Path $stringArray

$Speed = 20
$commands = @{}
foreach($line in $content){
    $cmd  = $line.Replace(" ","").split(":")[0]
    $value = $line.Replace(" ","").split(":")[1]
    switch($cmd){
        "left" {
            $commands["leftDuration"] = $value 
            $commands["leftSpeed"] = $Speed * 10 # 100% speed
        }
       "right" {
            $commands["rightDuration"] = $value 
            $commands["rightSpeed"] = $Speed * 10 # 100% speed
        }
    }
}
$messageString = $commands | convertto-json
$cloudClient = [Microsoft.Azure.Devices.ServiceClient]::CreateFromConnectionString($iotConnString)
$messagetosend = [Microsoft.Azure.Devices.Message]([Text.Encoding]::ASCII.GetBytes($messageString))
$cloudClient.SendAsync($deviceId, $messagetosend)