# AzAccount 연결
# Connect-AzAccount

# ResourceGroup 생성
$resourceGroup = New-AzResourceGroup `
    -Name 'az1000301-RG' `
    -Location 'koreacentral'

# location 저징
$location = $resourceGroup.Location

# Availability Set 생성
$availabilitySet = New-AzAvailabilitySet `
    -ResourceGroupName $resourceGroup.ResourceGroupName `
    -Name 'az1000301-avset0' `
    -Location $location `
    -PlatformFaultDomainCount 2 `
    -PlatformUpdateDomainCount 2 `
    -Sku aligned

# Virtual Network 생성
$vnet = New-AzVirtualNetwork `
    -Name 'az1000301-RG-vnet' `
    -ResourceGroupName $resourceGroup.ResourceGroupName `
    -Location $location `
    -AddressPrefix '10.103.0.0/16'

# Subnet config 생성
$subnetConfig = Add-AzVirtualNetworkSubnetConfig `
    -Name 'subnet0' `
    -AddressPrefix '10.103.0.0/24' `
    -VirtualNetwork $vnet

# Subnet config VNET에 적용
$vnet | Set-AzVirtualNetwork

# Subnet ID 저장
$subnetid = (Get-AzVirtualNetwork `
    -Name $vnet.Name `
    -ResourceGroupName $resourceGroup.ResourceGroupName).Subnets.Id

# vmName 저장
$vmName = 'az1000301-vm0'
# vmSize 저장
$vmSize = 'Standard_DS2_v2'

# RDP Port Open
$rdpRule = New-AzNetworkSecurityRuleConfig `
    -Name "$vmName-nsg-Rule" `
    -Description "Allow RDP" `
    -Access "Allow" `
    -Protocol "TCP" `
    -Direction "Inbound" `
    -Priority "300" `
    -SourceAddressPrefix "Internet" `
    -SourcePortRange * `
    -DestinationAddressPrefix * `
    -DestinationPortRange 3389

# NSG 생성
$nsg = New-AzNetworkSecurityGroup `
    -ResourceGroupName $resourceGroup.ResourceGroupName `
    -Location $location `
    -Name "$vmName-nsg" `
    -SecurityRules $rdpRule

# Public IP 생성
$pip = New-AzPublicIpAddress `
    -Name "$vmName-pip1" `
    -ResourceGroupName $resourceGroup.ResourceGroupName `
    -Location $location `
    -AllocationMethod Dynamic 

# NIC 생성
$nic = New-AzNetworkInterface `
    -Name "$($vmName)$(Get-Random)" `
    -ResourceGroupName $resourceGroup.ResourceGroupName `
    -Location $location `
    -SubnetId $subnetid `
    -PublicIpAddressId $pip.Id `
    -NetworkSecurityGroupId $nsg.Id


# Network settings
# ------------------------------------------------------------

$adminUsername = 'mhsong'
$adminPassword = 'thdAudgns9)'

# PSCredentail object 생성
$adminCreds = New-Object PSCredential $adminUsername, ($adminPassword | ConvertTo-SecureString -AsPlainText -Force)
$publisherName = 'MicrosoftWindowsServer'
$offerName = 'WindowsServer'
$skuName = '2019-Datacenter'

# VMConfig object 생성
$vmConfig = New-AzVMConfig `
    -VMName $vmName `
    -VMSize $vmSize `
    -AvailabilitySetId $availabilitySet.Id

# VM - Network Interface Connect
Add-AzVMNetworkInterface `
    -VM $vmConfig `
    -Id $nic.Id

# VM Operating System 설정
Set-AzVMOperatingSystem `
    -VM $vmConfig `
    -Windows `
    -ComputerName $vmName `
    -Credential $adminCreds

# VM Source Image 설정
Set-AzVMSourceImage `
    -VM $vmConfig `
    -PublisherName $publisherName `
    -Offer $offerName `
    -Skus $skuName `
    -Version 'latest'

# VM OS Disk 설정
Set-AzVMOSDisk `
    -VM $vmConfig `
    -Name "$($vmName)_OsDisk_1_$(Get-Random)" `
    -StorageAccountType 'Standard_LRS' `
    -CreateOption fromImage

# VM Boot Diagnostic 설정
Set-AzVMBootDiagnostic `
    -VM $vmConfig `
    -Disable

# Azure VM 배포
$vm = New-AzVM `
  -ResourceGroupName $resourceGroup.ResourceGroupName `
  -Location $location `
  -VM $vmConfig


# Remove-AzResourceGroup -Name $resourceGroup.ResourceGroupName
# Remove-AzResourceGroup -Name 'NetworkWatcherRG'