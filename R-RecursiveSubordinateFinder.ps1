#requires -Modules ActiveDirectory
<#
.DESCRIPTION
    This script queries all the users from the hierarchy tree starting from a given manager all the way down in the tree recursively. The original purpose was to create a dynamic distribution list for all the subordinates for a given person.

.PARAMETER TopManagerUPN
    This should be the UPN of the manager where the search should start from.

.NOTES
    Author: Jozsef Odor <odorjozsef91@gmail.com>
	Creation date:  2023.08.28
#>

param(
    [parameter(Mandatory)]
    [ValidateScript({Get-Aduser -Filter {UserPrincipalName -eq $_}})]
    [string]
    $TopManagerUPN
)

#region Functions
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

Function Get-Folder {
    [CmdletBinding()]
    param (
        [Parameter()]
        [String]
        $initialDirectory=""
    )
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null

    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.Description = "Select a folder"
    $foldername.rootfolder = "MyComputer"
    $foldername.SelectedPath = $initialDirectory

    if($foldername.ShowDialog((New-Object System.Windows.Forms.Form -Property @{TopMost = $true; TopLevel = $true })) -eq "OK")
    {
        $folder += $foldername.SelectedPath
    }
    return $folder
}
#endregion

#region variables
$topManager = Get-Aduser -Filter {UserPrincipalName -eq $TopManagerUPN}
$subordinateList = @()
$shouldContinue = $true
$firstRound = $true
$levelCounter = 1
Write-Host "Collecting the users, it could take up to 5 minutes"
$users = Get-Aduser -filter {EmailAddress -ne "$null" -and Enabled -eq $true} -properties EmailAddress, Manager
$usersListWithIndex = $users | Group-Object -Property Manager -AsHashTable
#endregion

#region Main loop
while ($shouldContinue) {
    Write-Host "Level $levelCounter is under processing"
    if($firstRound){
        $currentLvlManagers = $topManager
    }else{
        $currentLvlManagers = $managersOnTheNextLvl
    }

    $managersInTheCurrentLvl = @()
    $managersOnTheNextLvl = @()
    $firstRound = $false

    foreach($currentLvlManager in $currentLvlManagers){
        $currentLvlCandidates = $usersListWithIndex[$currentLvlManager.DistinguishedName]

        if($null -ne $currentLvlCandidates){
            $managersInTheCurrentLvl += $currentLvlCandidates
        }else{
            Write-Verbose "$($currentLvlManager.Name) has no subordinates"
        }
    }

    $subordinateList += $managersInTheCurrentLvl

    foreach($nextLvlmanager in $managersInTheCurrentLvl){
        $nextLvlCandidates = $usersListWithIndex[$nextLvlmanager.DistinguishedName]

        if($null -ne $nextLvlCandidates){
            $managersOnTheNextLvl += $nextLvlCandidates
        }else{
            Write-Verbose "$($nextLvlmanager.Name) has no subordinates"
        }
    }

    $subordinateList += $managersOnTheNextLvl

    If([string]::IsNullOrEmpty($managersOnTheNextLvl)){
        $shouldContinue = $false
    }else{
        $levelCounter++
    }
}
#endregion

#region Export
if($subordinateList.count -eq 0){
    Write-Host "There are no direct reporters under the given person."
    Exit 0
}else{
    Write-Host "$($subordinateList.Count) people have been found on $levelcounter level deep."
}

$reportNeeded = New-Question -Question "Do you want to export the report?"

If($reportNeeded -eq 0){
    $path = Get-Folder
    $filePath = Join-Path $path "RecursiveSubordinatesReport.csv"
    $subordinates | Select-Object Name, UserPrincipalName, EmailAddress, Manager | Export-CSv $filePath -Delimiter ';' -Encoding UTF8
}
#endregion