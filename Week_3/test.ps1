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