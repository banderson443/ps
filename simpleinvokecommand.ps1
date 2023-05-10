$computerList = Get-Content -Path "C:\Path\to\Computers.txt"
$command = "Get-Process"

foreach ($computerName in $computerList) {
    Invoke-Command -ComputerName $computerName -ScriptBlock {
        Param($command)
        Invoke-Expression -Command $command
    } -ArgumentList $command
}
