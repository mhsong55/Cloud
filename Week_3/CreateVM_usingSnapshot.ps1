# $resourceGroupName = 'az1000301-RG'
# $snapshotName = 'OsDiskSnapshot'
$secondVmName = 'az1000301-vm1'
# $vmSize = 'Standard_DS2_v2'
# $vnetName = $vnet.Name

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
    -DiskName "$($secondVmName)_OsDisk_1_$(Get-Random)"

# Initialize virtual machine configuration
$vmConfig = New-AzVMConfig `
    -VMName $secondVmName `
    -VMSize $vmSize `
    -AvailabilitySetId $availabilitySet.Id

# Use the Managed Disk Resource Id to attach it to the virtual machine. Please change the OS type to linux if OS disk has linux OS
# -CreateOption Attach `

$vm = Set-AzVMOSDisk `
    -VM $vmConfig `
    -ManagedDiskId $disk.Id `
    -CreateOption fromImage `
    -Windows

# Create a public IP for the VM
$publicIp = New-AzPublicIpAddress `
    -Name ($secondVmName.ToLower()+'_pip2') `
    -ResourceGroupName $resourceGroupName `
    -Location $snapshot.Location `
    -AllocationMethod Dynamic

# Get the virtual network where virtual machine will be hosted
# $vnet = Get-AzVirtualNetwork `
#    -Name $vnet.Name `
#    -ResourceGroupName $resourceGroupName

# Create NIC in the first subnet of the virtual network
$nic = New-AzNetworkInterface `
    -Name ($secondVmName.ToLower()+'_nic2') `
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