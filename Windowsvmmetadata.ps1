
#Connect to Azure Account using a SPN or we can also use Connect-Azaccount
Disconnect-AzAccount 
$TenantId = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"                                            
$ClientId = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"                                            
$ClientSecret ="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"                                                
$passwd = ConvertTo-SecureString $ClientSecret -AsPlainText -Force
$pscredential = New-Object System.Management.Automation.PSCredential($ClientId, $passwd)
Connect-AzAccount -ServicePrincipal -Credential $pscredential -Tenant $tenantId
Set-azcontext "Free Trial"

#Fetch all the Windows VMs within the subscriptions
$WindowsVMs = Get-AzVM -Status| Where-Object {$_.PowerState -eq "VM running" -and $_.StorageProfile.OSDisk.OSType -eq "Windows"}

#Initialize the variable as a blank array, all the VMs metadata will be stored in this.
$VMmetadata=@()

#Looping through each Windows VM within the Subscription, we are using Invoke-AzVMRunCommand to run PS script within a VM
    foreach($VM in $WindowsVMs){

            [System.String]$ScriptBlock = {Invoke-RestMethod -Headers @{"Metadata"="true"} -Method GET -Uri "http://169.254.169.254/metadata/instance?api-version=2021-02-01" -UseBasicParsing| ConvertTo-Json -Depth 99 }
            $FileName = "RunScript.ps1"
            Out-File -FilePath $FileName -InputObject $ScriptBlock -NoNewline
            $VMmetadata += Invoke-AzVMRunCommand -ResourceGroupName $vm.ResourceGroupName -Name $VM.Name -CommandId 'RunPowerShellScript' -ScriptPath $FileName
            Remove-Item -Path $FileName -Force -ErrorAction SilentlyContinue
            }

Write-Output $VMmetadata

$vmmetadata |  Out-File "YourLocation\$((Get-Date).ToString("yyyyMMdd_HHmmss"))_VmMetaData.txt"
