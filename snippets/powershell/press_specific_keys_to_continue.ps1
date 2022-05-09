Write-Host "Press c or e to continue"

do {
  $key = [Console]::ReadKey($true)
  $value = $key.KeyChar

  if ($value -eq 'c' -Or $value -eq 'e') {
    Write-Host $value" is pressed, yay!"
  } else {
    Write-Host $value" is pressed, not 'c' or 'e'!"
  }
} while ($value -notmatch 'c|e')
