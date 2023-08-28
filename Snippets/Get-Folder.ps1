<#
.DESCRIPTION
This function shows a file browser window where the user can choose a folder to do something with it.
#>

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
    $foldername.AddToRecent = $true
    $foldername.SelectedPath = $initialDirectory

    if($foldername.ShowDialog((New-Object System.Windows.Forms.Form -Property @{TopMost = $true; TopLevel = $true })) -eq "OK")
    {
        $folder += $foldername.SelectedPath
    }
    return $folder
}

$filePath = Get-Folder