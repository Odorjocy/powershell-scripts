<#
.DESCRIPTION
This function draws a simple banner with a given text surrounded by an arbitrary character

.EXAMPLE
Show-Banner -Message "Show me an awesome banner"

Show-Banner -Message "Show me an awesome banner" -FillingChar $
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

Show-Banner -Message "Look, this is a cool banner!"