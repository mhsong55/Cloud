# $resourceGroupName = $resourceGroup.ResourceGroupName
<<<<<<< HEAD
$vmName = "$($vmNamePrefix)1"
=======
$vmName = $vmNamePrefix + "1"
>>>>>>> 7302e81ceb66c8ea98e1c579ff2ccbe2a8bb6fe5
$snapshotName = 'OsDiskSnapshot'

$vm = Get-AzVM `
    -ResourceGroupName $resourceGroupName `
    -Name $vmName

$snapshotConfig = New-AzSnapshotConfig `
    -SourceUri $vm.StorageProfile.OsDisk.ManagedDisk.Id `
    -Location $location `
    -CreateOption copy

New-AzSnapshot `
    -Snapshot $snapshotConfig `
    -SnapshotName $snapshotName `
    -ResourceGroupName $resourceGroupName
