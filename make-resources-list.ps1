$cd = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $cd

$hashList = Join-Path $cd "resources.txt"

$baseUri = "https://raw.githubusercontent.com/cosmolen/ACT.Hojoring.Resources/master/"

Write-Output "# Hojoring.Resources" > $hashList

$files = Get-ChildItem .\ -Recurse

$prevDirectory = ""

foreach ($f in $files) {
    if ($f.PSIsContainer) {
        continue
    }

    if ($cd -eq $f.Directory) {
        continue
    }

    $relayPath = Resolve-Path $f.FullName -Relative

    Write-Output $relayPath

    $localPath = $relayPath.Replace(".\", "")
    $remoteUri = $baseUri + $localPath.Replace("\", "/")

    $hash = Get-FileHash $f.FullName -Algorithm MD5

    if ($prevDirectory -ne $f.Directory.ToString()) {
        Write-Output "" >> $hashList
        Write-Output ("# " +  (Resolve-Path $f.Directory -Relative).Replace(".\", "")) >> $hashList
    }

    Write-Output ($localPath + " " + $remoteUri + " " + $hash.Hash) >> $hashList

    $prevDirectory = $f.Directory.ToString()
}
