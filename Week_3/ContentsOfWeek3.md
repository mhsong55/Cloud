---
title: "Education contents of Week3"
---

# Education of Week 3

| Week | 분류 | 교육 내용 | 교육 담당 |
|:---:|:---:|:---:|:---:| 
|4주|Compute|Azure VM, VMSS<br>가용성 집합, 가용성 존<br>단일 vmNIC에 여러 개의 IP 할당<br>다수의 VM 배포 작업 (Portal, CLI, PowerShell, template)<br>Snapshot 생성, Custom Image 생성<br>VM Scale-Set|임승현|

# 1. **Availability Set**과 **Availability Zone**

## 1.1. Availability Set

    가상 머신의 서비스 가용성을 보장하기 위해서 장애 도메인(Fault Domain; FD)과 업데이트 도메인(Update Domain; UD)으로 가상 머신을 구성하는 집합이다.

> ### **Availability**
>
>   사용자가 data와 service를 정상적으로 사용가능한 정도를 의미한다. 일반적으로 time percentage per year로 표현한다.
> 
> $$Availability (\%) = \cfrac{Uptime}{Uptime+Downtime}$$
> 
> * Uptime : System 이 정상적으로 가동되는 상태 <br>
> * Downtime : System 이 오프라인 혹은 사용할 수 없는 상태 <br>
> * High Availability : 일정 수준 이상의 높은 가용성 <br>
>
> * 가용성의 예시 <br>
> 
> |가용성 (%)|오류율 (%)|초 (s)|분 (m)|시 (h)|일 (d)|
> |:---:|:---:|:---:|:---:|:---:|:---:|
> |99.95|0.05|1,576,800|26,280|438|18.25|
> |99.995|0.005|157,680|2,628|43.8|1.825|
> |99.9995|0.0005|15,768|262.8|4.38|0.1825|

<br>
가용성 집합 자체에 대한 비용은 없다. Azure는 가용성 집합 내에 배치한 VM을 여러 물리적 서버, 컴퓨팅 랙, 스토리지 단위 및 네트워크 스위치에서 실행되도록 한다. 하드웨어나 소프트웨어 장애가 발생하면, VM의 하위 집합만 영향을 받고 전체 솔루션은 작동 상태를 유지한다. availability set은 안정적인 클라우드 솔루션을 구축하는데 필수적이다.
<br><br>

- 장애 도메인 (Fault Domain)
  - 동일한 전원과 네트워크 스위치를 사용하는 가상 머신의 집합을 뜻하며, 이는 하나의 물리적인 Rack을 의미
- 업데이트 도메인 (Update Domain)
  - Azure의 계획된 유지 관리로 인해 운용 중인 Host의 Update를 진행할 때, 동시에 진행되는 Host group (가상 머신이 수용되는 host)
  - 동시에 2 개 이상의 Update domain에 대해서 update하지 않기 때문에 Update Domain을 분리하면 유지 보수로 인한 Host 재기동과 같은 상황에서 서비스 유지 가능

<center><img src="./img/ud-fd-configuration.png" width="50%"></center>


201019 교육

Azure VM

VM SKU(Stock Keeping Unit, 상품 품목)에 따라

Storage account

Accelerated Networking
VM에 대한 단일 루트 I/O 가상화 (SR-IOV)를 구현, 네트워킹 성능이 크게 향상

사용자 지정 스크립트 확장 (custom script extension)

---

# VM 배포하기

Windows server 실행하는 VM을 가용성 집합에 배포

## Powershell로 배포하기

1. Sign in
    
    ```powershell
    Connect-AzAccount
    ```

2. Resource Group 생성
    
    ```powershell
    $resourceGroup = New-AzResourceGroup `
      -Name 'az1000301-RG' `
      -Location 'koreacentral'
    ```

3. location 저장
    
    ```powershell
    $location = $resourceGroup.Location
    ```

4. Availability Set 생성
    
    ```powershell
    $availabilitySet = New-AzAvailabilitySet `
      -ResourceGroupName $resourceGroup.ResourceGroupName `
      -Name 'az1000301-avset0' `
      -Location $location `
      -PlatformFaultDomainCount 2 `
      -PlatformUpdateDomainCount 2 `
      -Sku aligned # 
    ```

5. Virtual Network 생성
    
    ```powershell
    $vnet = New-AzVirtualNetwork `
      -Name 'az1000301-RG-vnet' `
      -ResourceGroupName $resourceGroup.ResourceGroupName `
      -Location $location `
      -AddressPrefix '10.103.0.0/16'
    ```

6. Subnet config 생성
    
    ```powershell
    $subnetConfig = Add-AzVirtualNetworkSubnetConfig `
     -Name 'subnet0' `
     -AddressPrefix '10.103.0.0/24' `
     -VirtualNetwork $vnet
    ```

7. Subnet config VNET에 적용
    
    ```powershell
    $vnet | Set-AzVirtualNetwork
    ```

8. vmName 저장
    
    ```powershell
    $vmName = 'az1000301-vm0'
    ```

9. vmSize 저장
    
    ```powershell
    $vmSize = 'Standard_DS2_v2'
    ```

10. Subnet ID 저장
    
    ```powershell
    $subnetid = (Get-AzVirtualNetwork `
      -Name $vnet.Name `
      -ResourceGroupName $resourceGroup.ResourceGroupName).Subnets.Id
    ```

11. RDP Port Open rule 생성
    
    ```powershell
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
    ```

12. NSG 생성 및 RDP port open rule 적용
    
    ```powershell
    $nsg = New-AzNetworkSecurityGroup `
      -ResourceGroupName $resourceGroup.ResourceGroupName `
      -Location $location `
      -Name "$vmName-nsg" `
      -SecurityRules $rdpRule
    ```

13. Public IP 생성
    
    ```powershell
    $pip = New-AzPublicIpAddress `
      -Name "$vmName-ip" `
      -ResourceGroupName $resourceGroup.ResourceGroupName `
      -Location $location `
      -AllocationMethod Dynamic 
    ```

14. NIC 생성
    
    ```powershell
    $nic = New-AzNetworkInterface `
      -Name "$($vmName)$(Get-Random)" `
      -ResourceGroupName $resourceGroup.ResourceGroupName `
      -Location $location `
      -SubnetId $subnetid `
      -PublicIpAddressId $pip.Id `
      -NetworkSecurityGroupId $nsg.Id
    ```

15. RDP admin username & password 저장
    
    ```powershell
    $adminUsername = 'adminUser'
    $adminPassword = 'password112233'
    ```

16. PSCredential object 생성
    
    ```powershell
    $adminCreds = New-Object PSCredential $adminUsername, ($adminPassword | ConvertTo-SecureString -AsPlainText -Force)
    ```

17. publisherName 저장
    
    ```powershell
    $publisherName = 'MicrosoftWindowsServer'
    ```

18. offerName 저장
    
    ```powershell
    $offerName = 'WindowsServer'
    ```

19. skuName 저장
    
    ```powershell
    $skuName = '2019-Datacenter'
    ```

20. VMConfig object 생성
    
    ```powershell
    $vmConfig = New-AzVMConfig `
      -VMName $vmName `
      -VMSize $vmSize `
      -AvailabilitySetId $availabilitySet.Id
    ```

21. VM - Network Interface Connect
    
    ```powershell
    Add-AzVMNetworkInterface `
      -VM $vmConfig `
      -Id $nic.Id
    ```

22. VM Operating System 설정
    
    ```powershell
    Set-AzVMOperatingSystem `
      -VM $vmConfig `
      -Windows `
      -ComputerName $vmName `
      -Credential $adminCreds
    ```

23. VM Source Image 설정
    
    ```powershell
    Set-AzVMSourceImage `
      -VM $vmConfig `
      -PublisherName $publisherName `
      -Offer $offerName `
      -Skus $skuName `
      -Version 'latest'
    ```

24. VM OS Disk 설정
    
    ```powershell
    Set-AzVMOSDisk `
      -VM $vmConfig `
      -Name "$($vmName)_OsDisk_1_$(Get-Random)" `
      -StorageAccountType 'Standard_LRS' `
      -CreateOption fromImage
    ```

25. VM Boot Diagnostic 설정

    ```powershell
    Set-AzVMBootDiagnostic `
      -VM $vmConfig `
      -Disable
    ```

## Template으로 배포하기

## Azure CLI로 배포하기