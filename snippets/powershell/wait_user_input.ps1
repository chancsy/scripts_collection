do {
    $msg = 'Updates found, proceed with update? [Y/N]'
    $response = Read-Host -Prompt $msg
  
    if ($response -eq 'y' -OR $response -eq 'n') {
        Write-Host "You entered:" $response
    } else {
        Write-Host "Please try again."
    }
  } until ($response -eq 'y' -OR $response -eq 'n')
