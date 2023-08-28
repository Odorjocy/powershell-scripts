<#
.DESCRIPTION
This is an easy way to ask the user a yes or no question.
#>

Function New-Question {
    [CmdletBinding()]
    param (
        [Parameter()]
        $Question = "Do you want to proceed further?",
        [Parameter()]
        $Prompt = "Enter your choice",
        [Parameter()]
        $Choices = [System.Management.Automation.Host.ChoiceDescription[]] @("&Yes", "&No", "&Cancel"),
        [Parameter()]
        $Default = 1
    )

    $Choice = $host.UI.PromptForChoice($Question, $Prompt, $Choices, $Default)

    if($Choice -eq 2){
        Exit 0
    }

    Return $Choice
}

$title = "Do you want to proceed further?"
$prompt = "Enter your choice"
$choices = [System.Management.Automation.Host.ChoiceDescription[]] @("&Yes", "&No", "&Cancel")
$default = 1

# Prompt for the choice
$choice = $host.UI.PromptForChoice($title, $prompt, $choices, $default)

#region Function usage
$choice = New-Question -Question $title -Prompt $prompt
#endregion

# Action based on the choice
switch($choice)
{
    0 { Write-Host "Yes - Write your code"}
    1 { Write-Host "No - Write your code"}
    2 { Write-Host "Cancel - Write your code"}
}