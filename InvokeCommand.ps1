$path = "C:\Path\to\Computers.txt"
$outputPath = "C:\Path\to\Output.csv"
$command = "Get-Process"

# check if the path exists
if (!(Test-Path -Path $path)) {
    Write-Error "the computer list '$path' does not exist."
    return
}

$computerList = Get-Content -Path $path

# check if the list is empty
if (!$computerList) {
    Write-Error "the computer list '$path' does not contain any computer names."
    return
}

$results = foreach ($computerName in $computerList) {
    # check if the computer is reachable
    if (!(Test-Connection -ComputerName $computerName -Count 1 -Quiet)) {
        Write-Error "the computer '$computerName' is not reachable."
        continue
    }
    
    try {
        Invoke-Command -ComputerName $computerName -ScriptBlock {
            Param($command, $computerName)
            $processes = Invoke-Expression -Command $command
            $processes | Select-Object *,@{Name='ComputerName';Expression={$computerName}}
        } -ArgumentList $command, $computerName
    } catch {
        Write-Error "failed to  invokeCommand on '$computerName': $_"
    }
}

if ($results) {
    $results | Export-Csv -Path $outputPath -NoTypeInformation
} else {
    Write-Warning "no results to write to the output file."
}
