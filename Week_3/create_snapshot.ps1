$vmName = 'az1000301-vm0'
$resourceGroupName = 'az1000301-RG'
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
    -ResourceGroupName $resourceGroup.ResourceGroupName