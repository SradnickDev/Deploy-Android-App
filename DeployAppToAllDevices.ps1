#requires -Version 3.0
Function Deploy-App
{
  $devices = adb.exe devices
  
  $file = Get-ChildItem -Path $PSScriptRoot -Filter *.apk
  $fileName = $file.Name

  For ($i = 1; $i -le $devices.Length-2; $i++) 
  {
    Write-Output ('>> {0}' -f $devices[$i])
    $device = $devices[$i].Substring(0,$devices[$i].Length - 7)  
    adb.exe -s $device install -r $file
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

Show-Confirmation -messasge ('Push and Install to all connected devices ?')
Deploy-App