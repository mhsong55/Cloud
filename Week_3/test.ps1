Connect-AzAccount

Get-AzContext
# 구독 확인

$vmName = 'az1000301-vm1'
$vmSize = 'Standard_DS2_v2'
$resourceGroup = New-AzResourceGroup -Name 'az1000301-RG' -Location: 'Korea Central'
$location = $resourceGroup.Loation

$availabilitySet = Get-AzAvailabilitySet -ResourceGroupName $resourceGroup.ResourceGroupName -Name 'az1000301-avset0'
$vnet = Get-AzVirtualNetwork -Name 'az1000301-RG-vnet' -ResourceGroupName $resourceGroup.ResourceGroupName
$subnetid = (Get-AzVirtualNetworkSubnetConfig -Name 'subnet0' -VirtualNetwork $vnet).Id


$resourceGroup = New-AzResourceGroup `
    -Name 'az1000301-RG' `
    -Location 'koreacentral'
$availabilitySet = New-AzAvailabilitySet `
    -ResourceGroupName $resourceGroup.ResourceGroupName `
    -Name 'az1000301-avset0'
    -Location $resourceGroup.Location
$vnet = New-AzVirtualNetwork `
    -Name 'az1000301-RG-vnet' `
    -ResourceGroupName $resourceGroup.ResourceGroupName `
    -Location $resourceGroup.Location `
    -AddressPrefix '10.103.0.0/16'
$subnetConfig = Add-AzVirtualNetworkSubnetConfig `
    -Name 'subnet0' `
    -AddressPrefix '10.103.0.0/24' `
    -VirtualNetwork $vnet