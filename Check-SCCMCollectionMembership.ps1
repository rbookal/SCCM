Function Check-SCCMCollectionMembership{
    [cmdletbinding()]
    Param (
	    [string]$CollectionName = $(Throw "You must specify target collection name"),
	    [string]$ComputerName = $Env:COMPUTERNAME,
        [string]$SMSManagementServer = "SMSSERVER.COM"
    )

    # Get connection details for SCCM server
    $SmsAuthority = Get-WmiObject -Namespace "Root\CCM" -Class "SMS_Authority"
    [String]$SMSSiteCode = $SmsAuthority.Name.Remove(0, 4)

    write-verbose "Site code: $SmsSiteCode"
    write-verbose "Management server: $SmsManagementServer"

    write-verbose "Retrieving target collection"
    # Get reference to target collection
    $SmsCollection = Get-WmiObject -ComputerName $SMSManagementServer -Namespace "Root\Sms\Site_$SmsSiteCode" -Query "Select * From SMS_Collection Where Name='$($CollectionName)'"
    try
        {
            $SmsCollection.Get()
        }
    catch 
    {
        Write-Verbose "Collection $SmsCollection not found"
    }
    $computers = Get-CimInstance -ComputerName $SMSManagementServer -Namespace "Root\Sms\Site_$SmsSiteCode" -ClassName sms_fullcollectionmembership -Filter "CollectionID='$($SmsCollection.collectionid)'" | select -ExpandProperty name
    Write-Verbose "Collection contains: $($computers)"
    $Computers -contains $ComputerName

}