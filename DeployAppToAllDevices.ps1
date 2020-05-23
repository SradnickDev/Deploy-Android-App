#requires -Version 3.0

Function Deploy-App
{
  $file = Get-ChildItem -Path $PSScriptRoot -Filter *.apk
  
  if(!$file)
  {
    Write-Output -InputObject 'No file found.'
    return
  }
  $fileName = $file.Name
  Write-Output -InputObject ('Deploy App {0}' -f $fileName)
  $devices = adb.exe devices
  

  For ($i = 1; $i -le $devices.Length-2; $i++) 
  {
    Write-Output -InputObject ('>> {0}' -f $devices[$i])
    $device = $devices[$i].Substring(0,$devices[$i].Length - 7)  
    adb.exe -s $device install -r $file
  }
}

Deploy-App
