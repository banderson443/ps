$computerList = Get-Content -Path "C:\Path\to\Computers.txt"
$command = "Get-Process"

$results = foreach ($computerName in $computerList) {
    Invoke-Command -ComputerName $computerName -ScriptBlock {
        Param($command, $computerName)
        $processes = Invoke-Expression -Command $command
        $processes | Select-Object *,@{Name='ComputerName';Expression={$computerName}}
    } -ArgumentList $command, $computerName
}

$results | Export-Csv -Path "C:\Path\to\Output.csv" -NoTypeInformation