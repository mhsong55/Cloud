# $resourceGroupName = $resourceGroup.ResourceGroupName
$vmName = "$($vmNamePrefix)1"
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