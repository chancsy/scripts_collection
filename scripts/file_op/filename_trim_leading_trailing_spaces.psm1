function Get-ChildPath {
    param (
        [Parameter (Mandatory = $true)] [String]$ParentDir,
        [Parameter (Mandatory = $true)] [System.IO.FileSystemInfo]$File
    )
    return $File.FullName.Replace($ParentDir, "")
}
function Build-FileList_FilesBeforeDir {
    param (        
        [Parameter (Mandatory = $true)] [String]$Path,
        [Parameter (Mandatory = $false)] [Bool]$Recurse
    )
    if ($Recurse) {
        $list = @(Get-ChildItem -File -Recurse -LiteralPath $path) # Add list of files first
        $list += @(Get-ChildItem -Directory -Recurse -LiteralPath $path) # Add list of directories next
    } else {
        $list = @(Get-ChildItem -LiteralPath $path)
    }
    return $list
}
function Rename-FileName {
    param (
        [Parameter (Mandatory = $true)] [System.IO.FileSystemInfo]$PathParent,
        [Parameter (Mandatory = $true)] [System.IO.FileSystemInfo]$File
    )

    $result = 0
    if ($File.BaseName.StartsWith(" ") -or $File.BaseName.EndsWith(" ")) {
        [System.IO.FileInfo]$File_Trimmed = Join-Path -Path (Split-Path $File -Parent) -ChildPath ($File.BaseName.Trim() + $File.Extension)
        $Log_ChildPath_Trimmed = Get-ChildPath -ParentDir $PathParent -File $File_Trimmed
        Rename-Item -LiteralPath $File -NewName $File_Trimmed
        $result = 1
    } else {
        $Log_ChildPath_Trimmed = "No Change"
    }
    if ($File -is [System.IO.FileInfo]) {
        $Log_Object_Type = "File"
    } elseif ($File -is [System.IO.DirectoryInfo]) {
        $Log_Object_Type = "Dir "
    }
    $Log_ChildPath_Original = Get-ChildPath -ParentDir $PathParent -File $File
    Write-Verbose $("$Log_Object_Type`: ""$Log_ChildPath_Original"" -> ""$Log_ChildPath_Trimmed""")
    return $result
}
function Rename-FileNames {
    
<#
.SYNOPSIS
    Trim leading and trailing spaces in filename of all files under a directory.

.EXAMPLE
    Perform rename operation on files under "C:\MyFolder":
        Rename-FileNames "C:\MyFolder"

    Perform rename operation on files under "C:\MyFolder" recursively:
        Rename-FileNames "C:\MyFolder" -Recurse

    Perform rename operation with verbose output:
        Rename-FileNames "C:\MyFolder" -Verbose

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
        [Parameter (Mandatory = $true)] [String]$Path,
        [switch] $Recurse
    )

    if (-Not (Test-Path -LiteralPath $Path)) {
        Throw $("Path does not exist, script terminated.")
    }

    # Resolve path
    if ([System.IO.Path]::IsPathRooted($Path)) {
        if ((Get-Item -LiteralPath $Path) -is [System.IO.DirectoryInfo]) {
            [System.IO.DirectoryInfo]$Path_Resolved = $Path
        } else {
            [System.IO.FileInfo]$Path_Resolved = $Path
        }
    } else {
        if ((Get-Item -LiteralPath $Path) -is [System.IO.DirectoryInfo]) {
            [System.IO.DirectoryInfo]$Path_Resolved = Join-Path -Path $PWD -ChildPath $Path
        } else {
            [System.IO.FileInfo]$Path_Resolved = Join-Path -Path $PWD -ChildPath $Path
        }
    }

    $Log_cntProcessed = 0
    $Log_cntUpdated = 0

    $list = Build-FileList_FilesBeforeDir -Path $Path_Resolved -Recurse $Recurse
    $list | ForEach-Object {
        $result = Rename-FileName -PathParent $Path_Resolved -File $_
        if ($result -ne 0) {
            $Log_cntUpdated++
        }
        $Log_cntProcessed++
    }
    Write-Host ""
    Write-Host $("$Log_cntProcessed items processed.")
    Write-Host $("$Log_cntUpdated items renamed.")
}

Export-ModuleMember -Function Rename-FileNames
