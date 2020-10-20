#Connect-AzAccount

$resourceGroup = New-AzResourceGroup `
    -Name 'az1000301-RG' `
    -Location 'koreacentral'

$location = $resourceGroup.Location
$availabilitySet = New-AzAvailabilitySet `
    -ResourceGroupName $resourceGroup.ResourceGroupName `
    -Name 'az1000301-avset0' `
    -Location $location `
    -PlatformFaultDomainCount 2 `
    -PlatformUpdateDomainCount 2 `
    -Sku aligned
$vnet = New-AzVirtualNetwork `
    -Name 'az1000301-RG-vnet' `
    -ResourceGroupName $resourceGroup.ResourceGroupName `
    -Location $location `
    -AddressPrefix '10.103.0.0/16'
$subnetConfig = Add-AzVirtualNetworkSubnetConfig `
    -Name 'subnet0' `
    -AddressPrefix '10.103.0.0/24' `
    -VirtualNetwork $vnet
$vnet | Set-AzVirtualNetwork

# $cred = Get-Credential -Message "Enter a username and password for the virtual machine"
$vmName = 'az1000301-vm0'
$vmSize = 'Standard_DS2_v2'
$subnetid = (Get-AzVirtualNetwork `
    -Name $vnet.Name `
    -ResourceGroupName $resourceGroup.ResourceGroupName).Subnets.Id
$nsg = New-AzNetworkSecurityGroup `
    -ResourceGroupName $resourceGroup.ResourceGroupName `
    -Location $location `
    -Name "$vmName-nsg"
$pip = New-AzPublicIpAddress `
    -Name "$vmName-ip" `
    -ResourceGroupName $resourceGroup.ResourceGroupName `
    -Location $location `
    -AllocationMethod Dynamic 
$nic = New-AzNetworkInterface `
    -Name "$($vmName)$(Get-Random)" `
    -ResourceGroupName $resourceGroup.ResourceGroupName `
    -Location $location `
    -SubnetId $subnetid `
    -PublicIpAddressId $pip.Id `
    -NetworkSecurityGroupId $nsg.Id
$adminUsername = 'Student'
$adminPassword = 'Pa55w.rd1234'
$adminCreds = New-Object PSCredential $adminUsername, ($adminPassword | ConvertTo-SecureString -AsPlainText -Force)
$publisherName = 'MicrosoftWindowsServer'
$offerName = 'WindowsServer'
$skuName = '2019-Datacenter'
# $osDiskType = (Get-AzDisk -ResourceGroupName $resourceGroup.ResourceGroupName)[0].Sku.Name
$vmConfig = New-AzVMConfig `
    -VMName $vmName `
    -VMSize $vmSize `
    -AvailabilitySetId $availabilitySet.Id
Add-AzVMNetworkInterface `
    -VM $vmConfig `
    -Id $nic.Id
Set-AzVMOperatingSystem `
    -VM $vmConfig `
    -Windows `
    -ComputerName $vmName `
    -Credential $adminCreds 
Set-AzVMSourceImage `
    -VM $vmConfig `
    -PublisherName $publisherName `
    -Offer $offerName `
    -Skus $skuName `
    -Version 'latest'
Set-AzVMOSDisk `
    -VM $vmConfig `
    -Name "$($vmName)_OsDisk_1_$(Get-Random)" `
    -StorageAccountType 'Standard_LRS' `
    -CreateOption fromImage
Set-AzVMBootDiagnostic `
    -VM $vmConfig `
    -Disable

New-AzVM -ResourceGroupName $resourceGroup.ResourceGroupName -Location $location -VM $vmConfig