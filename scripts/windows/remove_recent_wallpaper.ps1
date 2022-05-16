# Select & remove wallpaper history from HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers

0..4 | ForEach-Object {
    $PropertyName = "BackgroundHistoryPath"+$_.ToString()
    New-Variable -Name "bg$_" -Value (Get-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers -Name $PropertyName).$PropertyName
    Write-Host $("Wallpaper "+$_+": "+(Get-Variable -Name bg$_ -ValueOnly))
}

Write-Host "Enter wallpaper # to remove from registry: [0/1/2/3/4]"
do {
    $key = [Console]::ReadKey($true)
    $value = $key.KeyChar
} while ($value -notmatch '0|1|2|3|4')

$PropertyName = "BackgroundHistoryPath"+$value
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers -Name $PropertyName -Value " "
