#Start the System Center Configuration Manager Software Updates Deployment Evaluation Scan
$trigger = '{00000000-0000-0000-0000-000000000108}'
$scan = Invoke-WmiMethod -ComputerName $server -Namespace root\ccm -Class sms_client -Name TriggerSchedule $trigger

[System.Management.ManagementObject[]] $CMMissingUpdates = @(GWMI -ComputerName $server -query "SELECT * FROM CCM_SoftwareUpdate WHERE ComplianceState = '0'" -namespace "ROOT\ccm\ClientSDK") #End Get update count.
(GWMI -ComputerName $server -Namespace "root\ccm\clientsdk" -Class "CCM_SoftwareUpdatesManager" -List).InstallUpdates($CMMissingUpdates)