# Test if argument is passed to function

function test {
    param (
        [Parameter (Mandatory = $false)] [String]$param
    )
    if ($PSBoundParameters.ContainsKey('param')) {
        $arg_len = $param.Length
        Write-Host $("Argument given with length $arg_len")
    } else {
        Write-Host Argument not given
    }
}

test "1"
test ""
test
