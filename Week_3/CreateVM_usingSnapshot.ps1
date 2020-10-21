$resourceGroupName = 'az1000301-RG'
$snapshotName = 'OsDiskSnapshot'
$vmName = 'az1000301-vm0'
$vmSize = 'Standard_DS2_v2'
$vnetName = 'az1000301-RG-vnet'
$osDiskName = $vmName + "_OsDisk_1_" + (Get-Random)

$snapshot = Get-AzSnapshot `
    -ResourceGroupName $resourceGroupName `
    -SnapshotName $snapshotName

$diskConfig = New-AzDiskConfig `
    -Location $snapshot.Location `
    -SourceResourceId $snapshot.Id `
    -CreateOption Copy

$disk = New-AzDisk `
    -Disk $diskConfig `
    -ResourceGroupName $resourceGroupName `
    -DiskName $osDiskName

# Initialize virtual machine configuration
$vmConfig = New-AzVMConfig `
    -VMName $vmName `
    -VMSize $vmSize

# Use the Managed Disk Resource Id to attach it to the virtual machine. Please change the OS type to linux if OS disk has linux OS
$vm = Set-AzVMOSDisk `
    -VM $vmConfig `
    -ManagedDiskId $disk.Id `
    -CreateOption Attach `
    -Windows

# Create a public IP for the VM
$publicIp = New-AzPublicIpAddress `
    -Name ($vmName.ToLower()+'_pip2') `
    -ResourceGroupName $resourceGroupName `
    -Location $snapshot.Location `
    -AllocationMethod Dynamic

# Get the virtual network where virtual machine will be hosted
$vnet = Get-AzVirtualNetwork `
    -Name $vnetName `
    -ResourceGroupName $resourceGroupName

# Create NIC in the first subnet of the virtual network
$nic = New-AzNetworkInterface `
    -Name ($vmName.ToLower()+'_nic2') `
    -ResourceGroupName $resourceGroupName `
    -Location $snapshot.Location `
    -SubnetId $vnet.Subnets[0].Id `
    -PublicIpAddressId $publicIp.Id

$vm = Add-AzVMNetworkInterface `
    -VM $vm `
    -Id $nic.Id

# Create the virtual machine with Managed Disk
New-AzVM `
    -VM $vm `
    -ResourceGroupName $resourceGroupName `
    -Location $snapshot.Location