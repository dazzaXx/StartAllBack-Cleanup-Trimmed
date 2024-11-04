#Trimmed down version of "https://github.com/iandiv/StartAllBack-Cleanup", for automation with Task Scheduler.

#Wait for explorer to load what it needs to before executing. 
#Prevents script from killing explorer too early leading to it not restarting properly.

Write-Output "Waiting for 60 seconds"
sleep -s 60

Write-Output "Cleaning StartAllBack Keys!"

$keys = Get-Item -Path Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\* | Select-Object -ExpandProperty Name
$keys = $keys | Where-Object { $_ -cmatch '\{[a-z0-9]{8}-([a-z0-9]{4}-){3}[a-z0-9]{8}.*$' }

foreach ($key in $keys) {
    # Write-Output  ('key found:' + $key)

    #look for subkeys
    $subkeys = Get-Item -Path ('Registry::' + $key + "\*") | Select-Object -ExpandProperty Name
    $subkeys_count = $subkeys | Measure-Object | Select-Object -ExpandProperty Count
    if (-Not ($subkeys_count -eq 0)) {
        continue
    }
 
    Remove-Item -Path ('Registry::' + $key)
}

stop-process -name explorer –force
Write-Output "Done!"
sleep -s 2
