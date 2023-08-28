<#
.DESCRIPTION
Easy way to measure the runtime of a script. Put the object at the very beginning of the script, then check the elapsed time at the end
#>

$stopper = [system.diagnostics.stopwatch]::StartNew()
$stopper.Stop()
$stopper.Elapsed