function Get-ClipboardFirstLine {
    $cb = Get-Clipboard
    if ($cb -is [array]) {
        $cb = $cb[0]
    }
    return $cb
}

function WaitClipboardChange {
    $current = Get-ClipboardFirstLine
    #Write-Host "Current clipboard is:"$current
    do {
        Start-Sleep 0.2
        $new = Get-ClipboardFirstLine
    } while ($current -eq $new)
    return $new
}

do {
    $clipboard = WaitClipboardChange
    Write-Host $clipboard
} while (1)
