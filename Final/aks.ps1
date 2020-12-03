
$resourceGroupName = 'AKS'
$location = 'koreacentral'
$aksName = 'AKS-Cluster'
$applicationId = 'c1ddebba-4665-4cdc-9b3e-41030166dd9d'
$psAdCredential = Get-AzADAppCredential -ApplicationId $applicationId

$resourceGroup = New-AzResourceGroup `
    -Name $resourceGroupName `
    -Location $location

$aks = New-AzAks `
    -ResourceGroupName $resourceGroupName `
    -Name $aksName `
    -NodeCount 1 `
    -KubernetesVersion '1.18.10' `
    -NodeVmSize 'Standard_B2s' `
    -LoadBalancerSku 'Standard' `
    -NetworkPlugin 'azure'
    -ServicePrincipalIdAndSecret $psAdCredential

Import-AzAksCredential `
    -ResourceGroupName $resourceGroupName `
    -Name $aksName