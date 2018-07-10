
#$remote = Get-Credential

Function GetSCCMCacheSize
{
Param (
        [INT]$cachesize = 10000,
        [String]$ComputerName = "localhost"
        )

    $Cache = Get-WmiObject -ComputerName $ComputerName -Namespace ‘ROOT\CCM\SoftMgmtAgent’ -Class CacheConfig -Verbose
    "Cache size is " + $Cache.Size 

    if ($Cache.Size -ne $cachesize) 
    {
        Write-Output $Cache.Size + "about to set cache size to " + $cachesize
        $Cache.Size = $cachesize 
        $Cache.Put() 
        Restart-Service -Name CcmExec -Verbose
    }

    $Cache = Get-CimInstance -Namespace 'ROOT\CCM\SoftMgmtAgent' -ClassName CacheConfig -Verbose
}


Function SCCMSiteCode
{
Param (
        [boolean]$Setcode,
        [String]$code
        )
        
    $Setcode = $false 
    $sms = new-object –comobject “Microsoft.SMS.Client”

    
    if($Setcode)
    {
        $sms.SetAssignedSite($code)
    }
    else
    {
        $sms.GetAssignedSite()
    }
}

Function NewSCCMSiteCode
{
Param (
        [switch]$Setcode,
        [String]$code
        )
        
    
    $sms = new-object –comobject "Microsoft.SMS.Client"

    
    if($Setcode)
    {
        $sms.SetAssignedSite($code)
    }
    else
    {
        $sms.GetAssignedSite()
    }
}

