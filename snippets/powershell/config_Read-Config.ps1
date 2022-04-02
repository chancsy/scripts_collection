function Read-Config {
  param (
    [Parameter (Mandatory = $true)] [String]$ConfigFile,
    [Parameter (Mandatory = $true)] [String]$ConfigName
  )
  $config_line = Get-Content $ConfigFile | Select-String -Pattern $ConfigName
  $config_line.ToString().split("=")[-1]
}

# Read-Config -ConfigFile "..\..\config.ini" -ConfigName "version"
