
# 생성되어 있는 VM 을 가져와서 변수 'souruceVM'에 VM 객체 저장
$sourceVM = Get-AzVM `
    -Name $vmName `
    -ResourceGroupName $resourceGroupName