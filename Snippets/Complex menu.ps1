<#
.DESCRIPTION
The New-Menu function takes an array of options and draws a list from it broken down into a group of 10 makes the options scrollable and waits for input.
The Show-Banner function is a dependency of the main function.

.EXAMPLE
New-Menu -Question "What is your favorite color?" -Options $([enum]::GetValues([System.ConsoleColor]))
#>

function Show-Banner {
    param (
        [parameter()]
        [string]
        $Message,
        [parameter()]
        [string]
        $FillingChar = '#'
    )

    $paddedMessage = $Message.PadLeft($Message.Length+2)
    $paddedMessage = $paddedMessage.PadRight($paddedMessage.Length+2)
    $fillingLine = $FillingChar * $($paddedMessage.Length+2)

    $formatedMessage = @"
        $fillingLine
        $fillingChar$paddedMessage$FillingChar
        $fillingLine
"@
    Write-Host $formatedMessage
}

Function New-Menu {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]
        $Question,
        [Parameter(Mandatory)]
        [String[]]
        $Options
    )

    $firstIndex = 0
    $lastIndex  = 9
    Do{
        Clear-Host
        Show-Banner -Message $Question
        $counter = $firstIndex +1
        ($Options[$firstIndex..$lastIndex]) | Foreach-Object {"$counter. " +  $_;++$counter}

        Write-Host $("------------------------------")
        try {
            If(-not $ranOutOfoptions){
                Write-Host "(Hit enter to see further options)"
            }
            [int]$choice = Read-Host "Please provide your choice"
        }catch{}

        if (0 -ne $choice -and $choice -in $($firstIndex+1)..$($lastIndex+1)) {
            $terminate = $true
            Continue
        }elseif ($choice -eq 0) {

        }else{
            Write-Warning "Please provide a valid option!"
            Start-Sleep 3
            $wrongChoice = $true
        }

        If($ranOutOfoptions -and -not $wrongChoice){
            $firstIndex = 0
            $lastIndex  = 9
            $ranOutOfoptions = $false
        }elseif($wrongChoice){
            $wrongChoice = $false
        }else{
            $firstIndex = $lastIndex
            $lastIndex  = $lastIndex + 10
        }

        If ($($lastIndex+1) -eq $($Options.Count)) {
            $ranOutOfoptions = $true
        }elseif ($($lastIndex+1) -gt $Options.Count) {
            $lastIndex = $Options.Count -1
            $ranOutOfoptions = $true
        }
    }until($terminate)
    Return $Options[$choice-1]
}

New-Menu -Question "What is your favorite color?" -Options $([enum]::GetValues([System.ConsoleColor]))