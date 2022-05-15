# Update pip packages (all / one-by-one)

# $outdated_package_list = pip list --outdated --format=freeze
Write-Host "Getting update lists... (pip list --outdated --format columns)"
$outdated_package_list = pip list --outdated --format columns

if ($outdated_package_list.length -eq 0) {
    Write-Host "No update found."
    return
}
$outdated_package_list
$update_list = $outdated_package_list[2..$outdated_package_list.length] # remove header rows

$update_list_name_only = @()
$update_list | ForEach-Object {
    $update_list_name_only += @($_.Substring(0, $_.IndexOf(" ")))
}

Write-Host 'Above updates, proceed? (answering yes will prompt for each package)? [A=All/Y=Yes/N=No]'
do {
    $key = [Console]::ReadKey($true)
    $value = $key.KeyChar
} while ($value -notmatch 'a|y|n')

# Update all packages
if ($value -eq 'a') {
    Write-Host "Updating all packages..."
    $update_list_name_only | ForEach-Object {
        pip install -U $_
    }
    return
}

# Update each package according to user's input
if ($value -eq 'y') {
    $update_list_name_only | ForEach-Object {
        Write-Host $("Update ""$_"" `? [Y=Yes/N=No]") 
        do {
            $key = [Console]::ReadKey($true)
            $value = $key.KeyChar
        } while ($value -notmatch 'y|n')
        if ($value -eq 'y') {
            Write-Host $("Installing $_...")
            pip install -U -q $_
        }
    }
    return
}
