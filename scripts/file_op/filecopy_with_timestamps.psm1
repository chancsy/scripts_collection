function Debug-DisplayList {
    param (
        [Parameter (Mandatory = $true)] [array]$list
    )
    $msg = "List of items to be processed:"
    Write-Debug $($msg+"-"*(80-$msg.Length))
    $list | ForEach-Object {
        Write-Debug $_
    }
    Write-Debug $("-"*80)
}
function Get-ChildPath {
    param (
        [Parameter (Mandatory = $true)] [String]$ParentDir,
        [Parameter (Mandatory = $true)] [System.IO.FileSystemInfo]$File
    )
    if ($ParentDir -eq $File.FullName) {
        return "\" + $File.Name
    } else {
        return $File.FullName.Replace($ParentDir, "")
    }
}
function Build-FileList {
    param (        
        [Parameter (Mandatory = $true)] [String]$Path,
        [Parameter (Mandatory = $false)] [Bool]$Recurse
    )
    if ($Recurse) {
        $list = Get-ChildItem -Recurse -LiteralPath $path
    } else {
        $list = Get-ChildItem -File -LiteralPath $path
    }
    return $list
}
function Get-RootedPath {
    param (
        [Parameter (Mandatory = $true)] [String]$Path
    )
    if ([System.IO.Path]::IsPathRooted($Path)) {
        return $Path
    } else {
        return Join-Path -Path $PWD -ChildPath $Path
    }
}

function Copy-ItemsWithTimeStampsCore {
    param (
        [Parameter (Mandatory = $true)] [System.IO.FileSystemInfo]$SrcParent,
        [Parameter (Mandatory = $true)] [System.IO.FileSystemInfo]$DestParent,
        [Parameter (Mandatory = $true)] [System.IO.FileSystemInfo]$File
    )
    $Src_ChildPath = Get-ChildPath -ParentDir $SrcParent -File $File
    Write-Debug $("Source ChildPath is $Src_ChildPath")
    $Dest = Join-Path -Path $DestParent -ChildPath $Src_ChildPath
    Write-Debug $("Destination is $Dest")

    if (Test-Path -LiteralPath $Dest) {
        if (((Get-Item -LiteralPath $File) -is [System.IO.DirectoryInfo]) -and (Get-Item -LiteralPath $Dest) -is [System.IO.FileInfo]) {
            Throw $("$Dest - A file exists with the same folder name to be copied and might affect copy operation, script will now terminate")
        }
        if (((Get-Item -LiteralPath $File) -is [System.IO.FileInfo]) -and (Get-Item -LiteralPath $Dest) -is [System.IO.DirectoryInfo]) {
            Throw $("$Dest - A folder exists with the same file name to be copied and might affect copy operation, script will now terminate")
        }
    }

    $continue = 'n'
    if (-Not (Test-Path -LiteralPath $Dest)) {
        $continue = 'y'
    } else {
        if ((Get-Item -LiteralPath $File) -is [System.IO.DirectoryInfo]) {
            return
        }
        do {
            $response = Read-Host -Prompt $("""$Src_ChildPath"" exists in destination, proceed with copy? [Y/N]")
            if ($response -eq 'y' -OR $response -eq 'n') {
                $continue = $response
            }
          } until ($response -eq 'y' -OR $response -eq 'n')
    }

    if ($continue -eq 'y') {
        Copy-Item -LiteralPath $File.FullName -Destination $Dest -Force
        Set-ItemProperty -LiteralPath $Dest -Name CreationTime -Value $File.CreationTime
        Set-ItemProperty -LiteralPath $Dest -Name LastWriteTime -Value $File.LastWriteTime
        Set-ItemProperty -LiteralPath $Dest -Name LastAccessTime -Value $File.LastAccessTime

        # Verbose Output
        if ($File -is [System.IO.FileInfo]) {
            $Log_Object_Type = "File"
        } elseif ($File -is [System.IO.DirectoryInfo]) {
            $Log_Object_Type = "Dir "
        }
        Write-Verbose $("$Log_Object_Type`: ""$Src_ChildPath""")
    }
}
function Copy-ItemsWithTimeStamps {
<#
.SYNOPSIS
    Copy files with time attributes.
    Source path (-Src) can be path to folder or file, destination path (-Dest) must be path to a folder

.EXAMPLE
    Copy files under "C:\MyFolder" to "C:\MyFolder 2"
        Copy-ItemsWithTimeStamps -Src "C:\MyFolder" -Dest "C:\MyFolder 2"

    Copy files under "C:\MyFolder" recursively:
        Copy-ItemsWithTimeStamps -Src "C:\MyFolder" -Dest "C:\MyFolder 2" -Recurse

    Perform copy operation with verbose output:
        Copy-ItemsWithTimeStamps -Src "C:\MyFolder" -Dest "C:\MyFolder 2" -Verbose

.INPUTS
    String

.OUTPUTS
    None

.NOTES
    Author:  SY Chan
    Website: https://soonyet.synology.com/wiki
#>

    [CmdletBinding()]
    param (
        [Parameter (Mandatory = $true)] [String]$Src,
        [Parameter (Mandatory = $true)] [String]$Dest,
        [switch] $Recurse
    )

    if (-Not (Test-Path -LiteralPath $Src)) {
        Throw $("Source path does not exist, script terminated.")
    }

    # Resolve path of $Src
    if ([System.IO.Path]::IsPathRooted($Src)) {
        if ((Get-Item -LiteralPath $Src) -is [System.IO.DirectoryInfo]) {
            [System.IO.DirectoryInfo]$Src_Resolved = $Src
        } else {
            [System.IO.FileInfo]$Src_Resolved = $Src
        }
    } else {
        if ((Get-Item -LiteralPath $Src) -is [System.IO.DirectoryInfo]) {
            [System.IO.DirectoryInfo]$Src_Resolved = Join-Path -Path $PWD -ChildPath $Src
        } else {
            [System.IO.FileInfo]$Src_Resolved = Join-Path -Path $PWD -ChildPath $Src
        }
    }

    # Resolve path of $Dest
    if ([System.IO.Path]::IsPathRooted($Dest)) {
        [System.IO.DirectoryInfo]$Dest_Resolved = $Src
    } else {
        [System.IO.FileInfo]$Dest_Resolved = Join-Path -Path $PWD -ChildPath $Dest
    }

    Write-Debug $("Source path given: $Src_Resolved")
    Write-Debug $("Dest path given: $Dest_Resolved")

    if ((Get-Item -LiteralPath $Src_Resolved) -is [System.IO.DirectoryInfo]) {
        Write-Debug "Source path is a dir"
    } else {
        Write-Debug "Source path is a file"
    }

    $list = Build-FileList -Path $Src_Resolved -Recurse $Recurse
    Debug-DisplayList $list
    $list | ForEach-Object {
        Copy-ItemsWithTimeStampsCore -SrcParent $Src_Resolved -DestParent $Dest_Resolved -File $_
    }
}

Export-ModuleMember -Function Copy-ItemsWithTimeStamps
