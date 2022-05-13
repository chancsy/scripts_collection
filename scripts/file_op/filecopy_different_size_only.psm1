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

function Copy-ItemsDifferentSizeOnlyCore {
    param (
        [Parameter (Mandatory = $true)] [System.IO.FileSystemInfo]$SrcParent,
        [Parameter (Mandatory = $true)] [System.IO.FileSystemInfo]$DestParent,
        [Parameter (Mandatory = $true)] [System.IO.FileSystemInfo]$File,
        [Parameter (Mandatory = $false)] [Bool]$Simulate
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
        $Src_FileSize = (Get-Item -LiteralPath $File).Length
        Write-Debug $("Src file size: $Src_FileSize")
        $Dest_FileSize = (Get-Item -LiteralPath $Dest).Length
        Write-Debug $("Dest file size: $Dest_FileSize")
        if ($Src_FileSize -ne $Dest_FileSize) {
            $continue = 'y'
        }
    }

    if ($continue -eq 'y') {
        if (-Not ($Simulate)) {
            Copy-Item -LiteralPath $File.FullName -Destination $Dest -Force
            Set-ItemProperty -LiteralPath $Dest -Name CreationTime -Value $File.CreationTime
            Set-ItemProperty -LiteralPath $Dest -Name LastWriteTime -Value $File.LastWriteTime
            Set-ItemProperty -LiteralPath $Dest -Name LastAccessTime -Value $File.LastAccessTime
        }

        # Verbose Output
        if ($File -is [System.IO.FileInfo]) {
            $Log_Object_Type = "File"
        } elseif ($File -is [System.IO.DirectoryInfo]) {
            $Log_Object_Type = "Dir "
        }
        Write-Verbose $("$Log_Object_Type`: ""$Src_ChildPath"" copied.")
    }
}
function Copy-ItemsDifferentSizeOnly {
<#
.SYNOPSIS
    Copy files excluding files with same file size.
    Source path (-Src) can be path to folder or file, destination path (-Dest) must be path to a folder

.EXAMPLE
    Copy files under "C:\MyFolder" to "C:\MyFolder 2"
        Copy-ItemsDifferentSizeOnly -Src "C:\MyFolder" -Dest "C:\MyFolder 2"

    Copy files under "C:\MyFolder" recursively:
        Copy-ItemsDifferentSizeOnly -Src "C:\MyFolder" -Dest "C:\MyFolder 2" -Recurse

    Perform copy operation with verbose output:
        Copy-ItemsDifferentSizeOnly -Src "C:\MyFolder" -Dest "C:\MyFolder 2" -Verbose

    Simulate copy operation:
        Copy-ItemsDifferentSizeOnly -Src "C:\MyFolder" -Dest "C:\MyFolder 2" -Verbose -Simulate

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
        [switch] $Recurse,
        [switch] $Simulate
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

    if (-Not (Test-Path -LiteralPath (Join-Path -Path $Src_Resolved -ChildPath "*"))) {
        Throw "Source folder is empty"
    }
    $list = Build-FileList -Path $Src_Resolved -Recurse $Recurse
    Debug-DisplayList $list
    $list | ForEach-Object {
        Copy-ItemsDifferentSizeOnlyCore -SrcParent $Src_Resolved -DestParent $Dest_Resolved -File $_ -Simulate $Simulate
    }
}

Export-ModuleMember -Function Copy-ItemsDifferentSizeOnly
