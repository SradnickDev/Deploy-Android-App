function Setup-Device
{
  $retVal = Show-Confirmation -messasge ('Do you want to connect a USB device?')
  if(!$retVal) 
  {
    return
  }

  #restart server
  Write-Output -InputObject 'Restart Server'
  adb.exe kill-server 2>$null | adb.exe start-server 2>$null
  
  Write-Output -InputObject 'Server running'
  Write-Output -InputObject 'retrieving ip adress'
  
  #retrieve ip
  $file = '{0}\devicesIp.txt' -f $PSScriptRoot
  $device = adb.exe shell ip route 2>$null

  if(!$device)
  {
    $confirmation = Read-Host -Prompt 'No device connected.(press any key to exit)'
    return
  }
  
  $pos = $device[2].IndexOf('src')
  $ipAdrr = $device[2].Substring($pos+4)

  $pos = $ipAdrr.IndexOf('metric')
  $ipAdrr = $ipAdrr.Substring(0,$pos-2)
  $ipAdrr = '{0}:5555' -f $ipAdrr
  
  
  # start tcp
  $cmdOutput = adb.exe tcpip 5555
  Write-Output -InputObject $cmdOutput
  Write-Output -InputObject 'Server Running'

  Add-Content $file -Value $ipAdrr
  Write-Output -InputObject "$ipAdrr added to File."
  
  Setup-Device
}

function Connect-Devices
{ 
  $retVal = Show-Confirmation -messasge ('Connect all Devices via WIFI ?')
  
  if(!$retVal) 
  {
    return
  }
  
  $file = '{0}\devicesIp.txt' -f $PSScriptRoot
  foreach($deviceIp in Get-Content -Path $file) 
  {
    adb.exe connect $deviceIp
  }
}

Function Show-Confirmation($messasge)
{
  $confirmation = Read-Host -Prompt ('{0} (y/n)' -f $messasge)
  if ($confirmation -eq 'y') 
  {
    return $true
  }
}


### Script Entry ###
Setup-Device
Connect-Devices