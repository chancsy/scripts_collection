# % to Complete
for ($i = 1; $i -le 100; $i++ ) {
    Write-Progress -Activity "Search in Progress" -Status "$i% Complete:" -PercentComplete $i
    Start-Sleep -Milliseconds 20
}

# Timer Countdown
function Start-SleepSecondsWithProgress {
    param (
      [Parameter (Mandatory = $true)] [int]$seconds
    )
    for ($i = 0; $i -lt $seconds; $i++ ) {
        $timeleft = (10-$i).ToString()
        Write-Progress -Activity "Please wait..." -Status $("$(($seconds-$i).ToString()) seconds left") -PercentComplete (100-$i*(100/$seconds)) -SecondsRemaining ($seconds-$i)
        Start-Sleep -Milliseconds 1000
    }
}
Start-SleepSecondsWithProgress 5
