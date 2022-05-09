# Read configuration from provided $ConfigFile and $ConfigName
# Format in "config_name=config_detail". e.g. "version=1.0.0"
#
# Usage example from another PowerShell script (test script "config_Read-Config_test.ps1"):
#   Import-Module "$PSScriptRoot/config_Read-Config.ps1" -Force
#   Read-Config -ConfigFile "$PSScriptRoot/config.ini" -ConfigName "version"

function Read-Config {
  param (
    [Parameter (Mandatory = $true)] [String]$ConfigFile,
    [Parameter (Mandatory = $true)] [String]$ConfigName
  )
  $config_line = Get-Content $ConfigFile | Select-String -Pattern $ConfigName
  $config_line.ToString().split("=")[-1]
}
