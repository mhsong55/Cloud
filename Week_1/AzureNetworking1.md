## Table of Contents

[Azure 일반](#azure-일반)

+---  [상태 어드바이저](#azure-상태-어드바이저)

[Azure Network 1](#azure-network-1)

+---  [1. Virtual Network (VNet)](#1.-virtual-network-(vnet))

+---  [2. Subnet](#2.-subnet)

+---  [3. VNet Peering](#3.-vnet-peering)

+---  [4. Nic (Network interface card)](#4.-nic-(network-interface-card))

+--- [5. Network Security Group](#5.-nsg-(network-security-group))

+--- [6. Load Balancer](#6.-load-balancer)

+--- [Health Probe](#health-probe)

+--- [VPN (Virtual Private Network)](#vpn-(virtual-private-network))

​		+--- [(1) P2S VPN](#(1)-p2s-(point-to-site)-vpn)

​		+--- [(2) S2S VPN](#(2)-s2s-(site-to-site)-vpn)

---

# Azure 일반

### 상태 어드바이저 : Azure Service Health

[Azure Service Health](https://docs.microsoft.com/ko-kr/azure/service-health/)

Azure는 클라우드 리소스의 상태에 대해 지속적으로 알려주는 Azure Service Health를 제공하며, Azure 서비스의 문제가 사용자에게 영향을 주는 경우 맞춤형 지침 및 지원을 제공한다. Azure Service Health는 Azure Health, Service Health, Resource Health 서비스라는 3가지 서비스로 구성되어 있다.



1. Azure status
   - Azure Status 페이지에서 Azure의 서비스 중단을 사용자에게 알려준다.
   - Azure 상태 페이지는 항상 최신 상태 정보를 표시하지만 상태 기록 페이지를 사용해 이전 이벤트를 볼 수 있다.
2. Service Health
   - 사용하는 영역에 있는 Azure 서비스의 상태를 추적하는 사용자 지정 가능한 대시보드를 제공한다.
   - 이벤트가 비활성화되면 최대 90일 동안 상태 기록에 저장된다.
   - Service Health 대시보드를 사요해 서비스 문제로 인해 영향이 발생할 경우 사전에 알리는 서비스 상태 경고를 만들고 관리할 수 있다.
3. Resource Health
   - Azure Resource Health를 통해 Azure Resource에 영향을 주는 서비스 문제를 진단하고 지원을 받을 수 있다.
   - 리소스의 현재와 과거 상태를 보고한다.
   - 리소스는 가상 머신, 웹 앱 또는 SQL Database와 같은 Azure 서비스의 특정 인스턴스이다.
   - Resource Health는 서로 다른 Azure 서비스의 신호에 의존하여 리소스가 정상인지 여부를 평가한다.

---



# Azure Network 1



## 1. Virtual Network (VNet)

- VNet 은 Azure에 있는 Private Network (일종의 Switch 단)인 독립된 하나의 네트워크 체계로, 논리적으로 격리된 가상의 네트워크

- 같은 VNet에 속한 리소스 (VM 등)는 내부적으로 통신 가능하지만 다른 VNet에 속한 리소스와는 기본적으로 내부 통신이 불가능

- 다른 VNet 끼리 통신을 하기 위해서는 VNet VPM 또는 VNet Peering을 통해 통신 가능

- Subnet은 기존 On-Premise의 Subnet과 동일한 개념

- IP 대역은 임의로 지정 가능



## 2. Subnet

- Subnet은 On-Premise에서의 Subnet과 동일하며, 서브넷 마스크로 만들어진 네트워크를 의미한다.
- 하나의 네트워크로 서로 나뉘어진 서브넷끼리는 라우터를 통해서만 통신이 가능하다.
- Subnetting의 목적은 **IP 주소를 보다 효율적으로 낭비없이 쓰기 위함**과 **큰 네트워크를 작게 쪼게어 브로드캐스트의 영향을 줄이기 위함**이다.
- 일반적으로 사용되는 TCP/IP인 Ethernet의 경우 CSMA/CD (Carrier Sense Multiple Access/Collision Detection) 방식으로 너무 잦은 브로드캐스트는 네트워크에 속한 모든 PC의 CPU 성능을 떨어뜨리고 네트워크에서 데이터 전송을 불가능하게 만들 수 있다.
- 따라서 Subnetting으로 브로드캐스트 도메인을 축소시켜 하나의 브로드캐스트에 영향을 덜 받게끔 하는것에 Subnetting의 한 목적이 있다.



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