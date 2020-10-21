---
title: "Education contents of Week3"
---

# Education of Week 3

| Week | 분류 | 교육 내용 | 교육 담당 |
|:---:|:---:|:---:|:---:| 
|4주|Compute|Azure VM, VMSS<br>가용성 집합, 가용성 존<br>단일 vmNIC에 여러 개의 IP 할당<br>다수의 VM 배포 작업 (Portal, CLI, PowerShell, template)<br>Snapshot 생성, Custom Image 생성<br>VM Scale-Set|임승현|

## Table of Contents

[1. Availability Set과 Availability Zone](#1-availability-set과-availability-zone)

[1.1 Availability Set](#11-availability-set)

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

```powershell
# AzAccount 연결
Connect-AzAccount

# ResourceGroup 생성
$resourceGroup = New-AzResourceGroup `
    -Name 'az1000301-RG' `
    -Location 'koreacentral'

# location 저징
$location = $resourceGroup.Location

# Availability Set 생성
$availabilitySet = New-AzAvailabilitySet `
    -ResourceGroupName $resourceGroup.ResourceGroupName `
    -Name 'az1000301-avset0' `
    -Location $location `
    -PlatformFaultDomainCount 2 `
    -PlatformUpdateDomainCount 2 `
    -Sku aligned

# Virtual Network 생성
$vnet = New-AzVirtualNetwork `
    -Name 'az1000301-RG-vnet' `
    -ResourceGroupName $resourceGroup.ResourceGroupName `
    -Location $location `
    -AddressPrefix '10.103.0.0/16'

# Subnet config 생성
$subnetConfig = Add-AzVirtualNetworkSubnetConfig `
    -Name 'subnet0' `
    -AddressPrefix '10.103.0.0/24' `
    -VirtualNetwork $vnet

# Subnet config VNET에 적용
$vnet | Set-AzVirtualNetwork

# Subnet ID 저장
$subnetid = (Get-AzVirtualNetwork `
    -Name $vnet.Name `
    -ResourceGroupName $resourceGroup.ResourceGroupName).Subnets.Id

# vmName 저장
$vmName = 'az1000301-vm0'
# vmSize 저장
$vmSize = 'Standard_DS2_v2'

# RDP Port Open
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

# NSG 생성
$nsg = New-AzNetworkSecurityGroup `
    -ResourceGroupName $resourceGroup.ResourceGroupName `
    -Location $location `
    -Name "$vmName-nsg" `
    -SecurityRules $rdpRule

# Public IP 생성
$pip = New-AzPublicIpAddress `
    -Name "$vmName-ip" `
    -ResourceGroupName $resourceGroup.ResourceGroupName `
    -Location $location `
    -AllocationMethod Dynamic 

# NIC 생성
$nic = New-AzNetworkInterface `
    -Name "$($vmName)$(Get-Random)" `
    -ResourceGroupName $resourceGroup.ResourceGroupName `
    -Location $location `
    -SubnetId $subnetid `
    -PublicIpAddressId $pip.Id `
    -NetworkSecurityGroupId $nsg.Id


# Network settings
# ------------------------------------------------------------

$adminUsername = 'mhsong'
$adminPassword = 'thdAudgns9)'

# PSCredentail object 생성
$adminCreds = New-Object PSCredential $adminUsername, ($adminPassword | ConvertTo-SecureString -AsPlainText -Force)
$publisherName = 'MicrosoftWindowsServer'
$offerName = 'WindowsServer'
$skuName = '2019-Datacenter'

# VMConfig object 생성
$vmConfig = New-AzVMConfig `
    -VMName $vmName `
    -VMSize $vmSize `
    -AvailabilitySetId $availabilitySet.Id

# VM - Network Interface Connect
Add-AzVMNetworkInterface `
    -VM $vmConfig `
    -Id $nic.Id

# VM Operating System 설정
Set-AzVMOperatingSystem `
    -VM $vmConfig `
    -Windows `
    -ComputerName $vmName `
    -Credential $adminCreds

# VM Source Image 설정
Set-AzVMSourceImage `
    -VM $vmConfig `
    -PublisherName $publisherName `
    -Offer $offerName `
    -Skus $skuName `
    -Version 'latest'

# VM OS Disk 설정
Set-AzVMOSDisk `
    -VM $vmConfig `
    -Name "$($vmName)_OsDisk_1_$(Get-Random)" `
    -StorageAccountType 'Standard_LRS' `
    -CreateOption fromImage

# VM Boot Diagnostic 설정
Set-AzVMBootDiagnostic `
    -VM $vmConfig `
    -Disable

# Azure VM 배포
$vm = New-AzVM `
  -ResourceGroupName $resourceGroup.ResourceGroupName `
  -Location $location `
  -VM $vmConfig
```

## ARM(Azure Resource Manager) Template으로 배포하기

### VMDeployment.json

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "vmNamePrefix": {
      "type": "string",
      "defaultValue": "az1000302-vm",
      "metadata": {
        "description": "VM name prefix"
      }
    },
    "nicNamePrefix": {
      "type": "string",
      "defaultValue": "az1000302-nic",
      "metadata": {
        "description": "Nic name prefix"
      }
    },
    "pipNamePrefix": {
      "type": "string",
      "defaultValue": "az1000302-ip",
      "metadata": {
        "description": "Public IP address name prefix"
      }
    },
    "adminUsername": {
      "type": "string",
      "metadata": {
        "description": "Admin username"
      }
    },
    "adminPassword": {
      "type": "securestring",
      "metadata": {
        "description": "Admin password"
      }
    },
    "imagePublisher": {
      "type": "string",
      "defaultValue": "MicrosoftWindowsServer",
      "metadata": {
        "description": "Image Publisher"
      }
    },
    "imageOffer": {
      "type": "string",
      "defaultValue": "WindowsServer",
      "metadata": {
        "description": "Image Offer"
      }
    },
    "imageSKU": {
      "type": "string",
      "defaultValue": "2019-Datacenter",
      "metadata": {
        "description": "Image SKU"
      }
    },
    "vmSize": {
      "type": "string",
      "defaultValue": "Standard_DS2_v2",
      "metadata": {
        "description": "VM size"
      }
    },
    "virtualNetworkName": {
      "type": "string",
      "defaultValue": "az1000301-RG-vnet",
      "metadata": {
        "description": "Virtual network name"
      }
    },
    "virtualNetworkResourceGroup": {
      "type": "string",
      "defaultValue": "az1000301-RG",
      "metadata": {
        "description": "Resource group of the VNet"
      }
    },
    "subnetName": {
      "type": "string",
      "defaultValue": "subnet0",
      "metadata": {
        "description": "Name of the VNet subnet"
      }
    }
  },
  "variables": {
    "availabilitySetName": "az1000302-avset1",
    "vnetID": "[resourceId(parameters('virtualNetworkResourceGroup'), 'Microsoft.Network/virtualNetworks', parameters('virtualNetworkName'))]",
    "subnetRef": "[concat(variables('vnetID'),'/subnets/',parameters ('subnetName'))]",
    "numberOfInstances": 2,
    "networkSecurityGroupName": "az1000302-vm-nsg"
  },
  "resources": [
    {
      "type": "Microsoft.Compute/availabilitySets",
      "name": "[variables('availabilitySetName')]",
      "apiVersion": "2018-06-01",
      "location": "[resourceGroup().location]",
      "sku": {
        "name": "Aligned"
      },
      "properties": {
        "platformFaultDomainCount": "2",
        "platformUpdateDomainCount": "5"
      }
    },
    {
      "name": "[concat(parameters('nicNamePrefix'), copyindex())]",
      "type": "Microsoft.Network/networkInterfaces",
      "apiVersion": "2018-08-01",
      "location": "[resourceGroup().location]",
      "copy": {
        "name": "nicLoop",
        "count": "[variables('numberOfInstances')]"
      },
      "dependsOn": [
        "[concat('Microsoft.Network/networkSecurityGroups/', variables('networkSecurityGroupName'))]",
        "pipLoop"
      ],
      "properties": {
        "ipConfigurations": [
          {
            "name": "ipconfig1",
            "properties": {
              "privateIPAllocationMethod": "Dynamic",
              "publicIpAddress": {
                "id": "[resourceId('Microsoft.Network/publicIpAddresses', concat(parameters('pipNamePrefix'), copyindex()))]"
              },
              "subnet": {
                "id": "[variables('subnetRef')]"
              }
            }
          }
        ],
        "networkSecurityGroup": {
          "id": "[resourceId('Microsoft.Network/networkSecurityGroups', variables('networkSecurityGroupName'))]"
        }
      }
    },
    {
      "name": "[concat(parameters('pipNamePrefix'), copyindex())]",
      "type": "Microsoft.Network/publicIpAddresses",
      "apiVersion": "2018-08-01",
      "location": "[resourceGroup().location]",
      "comments": "Public IP for Primary NIC",
      "copy": {
        "name": "pipLoop",
        "count": "[variables('numberOfInstances')]"
      },
      "properties": {
        "publicIpAllocationMethod": "Dynamic"
      }
    },
    {
      "apiVersion": "2018-06-01",
      "type": "Microsoft.Compute/virtualMachines",
      "name": "[concat(parameters('vmNamePrefix'), copyindex())]",
      "copy": {
        "name": "virtualMachineLoop",
        "count": "[variables('numberOfInstances')]"
      },
      "location": "[resourceGroup().location]",
      "dependsOn": [
        "[concat('Microsoft.Compute/availabilitySets/', variables('availabilitySetName'))]",
        "nicLoop"
      ],
      "properties": {
        "availabilitySet": {
          "id": "[resourceId('Microsoft.Compute/availabilitySets',variables('availabilitySetName'))]"
        },
        "hardwareProfile": {
          "vmSize": "[parameters('vmSize')]"
        },
        "osProfile": {
          "computerName": "[concat(parameters('vmNamePrefix'), copyIndex())]",
          "adminUsername": "[parameters('adminUsername')]",
          "adminPassword": "[parameters('adminPassword')]"
        },
        "storageProfile": {
          "imageReference": {
            "publisher": "[parameters('imagePublisher')]",
            "offer": "[parameters('imageOffer')]",
            "sku": "[parameters('imageSKU')]",
            "version": "latest"
          },
          "osDisk": {
            "createOption": "FromImage"
          }
        },
        "networkProfile": {
          "networkInterfaces": [
            {
              "id": "[resourceId('Microsoft.Network/networkInterfaces',concat(parameters('nicNamePrefix'),copyindex()))]"
            }
          ]
        }
      }
    },
    {
      "name": "[variables('networkSecurityGroupName')]",
      "type": "Microsoft.Network/networkSecurityGroups",
      "apiVersion": "2018-08-01",
      "location": "[resourceGroup().location]",
      "comments": "Network Security Group (NSG) for Primary NIC",
      "properties": {
        "securityRules": [
        ]
      }
    }
  ]
}
```

### VMDeployment.parameters.json
```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "adminUsername": {
            "value": "Student"
        },
        "adminPassword": {
            "value": "Pa55w.rd1234"
        }
    }
}
```

## Azure CLI로 배포하기