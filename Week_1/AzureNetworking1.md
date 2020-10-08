## Table of Contents

[Azure 일반](#azure-일반)

+---  [상태 어드바이저](#azure-상태-어드바이저)

[Azure Network 1](#azure-network-1)

+---  [1. Virtual Network (VNet)](#1.-virtual-network-(vnet))

+---  [2. Subnet](#2.-subnet)

+---  [3. VNet Peering](#3.-vnet-peering)

+---  [4. Nic (Network interface card)](#4.-nic-(network-interface-card))

+--- [5. Network Security Group](#5. nsg-(network-security-group))

+--- [6. Load Balancer](#6.-load-balancer)

+--- [Health Probe](#health-probe)

+--- [VPN (Virtual Private Network)](#vpn-(virtual-private-network))

​		+--- [(1) P2S VPN](#(1)-p2s-(point-to-site)-vpn)

​		+--- [(2) S2S VPN](#(2)-s2s-(site-to-site)-vpn)

---

# Azure 일반

### Azure 상태 어드바이저

- Azure Service Health



---



# Azure Network 1



## 1. Virtual Network (VNet)

- VNet 은 Azure에 있는 Private Network (일종의 Switch 단)인 독립된 네트워크 체계로, 논리적으로 격리된 가상의 네트워크

- 같은 VNet에 속한 리소스 (VM 등)는 내부적으로 통신 가능하지만 다른 VNet에 속한 리소스와는 기본적으로 내부 통신이 불가능

- 다른 VNet 끼리 통신을 하기 위해서는 VNet VPM 또는 VNet Peering을 통해 통신 가능

- Subnet은 기존 On-Premise의 Subnet과 동일한 개념

- IP 대역은 임의로 지정 가능



## 2. Subnet

Subnetting을 하는 이유



## 3. VNet Peering



## 4. Nic (Network interface card)

종속성 : Nic는 Subnet에 종속



## 5. NSG (Network Security Group)



## 6. Load Balancer

External, Internal Load Balancer



## Health Probe



## VPN (Virtual Private Network)



### (1) P2S (Point-to-Site) VPN



### (2) S2S (Site-to-Site) VPN

Azure VNet -------------------- IDC

ER -----------------------------------ER

VPN (Pub.IP)         VPN (Pub.IP)