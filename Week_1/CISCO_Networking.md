# CISCO Networking

## Part 01. 네트워크 세상에 들어서며

### Section 03. Networking의 정체

Networking 이란?

- 장비들을 서로 연결하는 것
- 장비들을 서로 대화가 가능하도록 묶어주는 것

---

### Section 04. 인터넷, 인트라넷, 엑스트라넷

#### 1. Internet 이란?

- "여러 개의 네트워크를 묶었다." 의 의미
- Internet 의 Inter 라는 의미는 _**연결**_  을 의미
  - International : 국제적인, 국제 간의 = 여러 나라를 묶을 때 사용
  - Intercontinental : "대륙을 묶는다" 는 의미
  - Interpol : 국제 경찰 = "경찰을 묶는다"
  - Interphone : 전화를 서로 묶어주는 역할
- 각각의 회사나 단체에서 자신들의 정보를 공유하고자 만들었던 네트워크를 좀 더 많은 사람들과 정보를 공유하고자 서로 연결하기 시작했는데, 이게 바로 인터넷의 시작.

- Internet 의 특징
  1. 하나의 Protocol 만 사용

     > ###### Protocol 이란?
     >
     > - 대화의 규칙, 인터넷에서는 통신의 규칙을 의미
     > - 한 사람은 한국어를 하는데 상대편은 한국어를 전혀 모르고 영어로만 이야기 한다면, 이 두 사람은 서로 Protocol 이 다르다고 이야기한다.
     > - Internet 의 Protocol 은 TCP/IP

  2. 주로 Web Browser 를 이용

  3. Internet 에는 없는 정보가 없다.

#### 2. IntraNet 이란?

- "내부의 네트워크" 의 의미
- 인터넷을 웹 브라우저만 가지고 사용하니 너무 편리하더라, 사내 업무도 웹 브라우저만 가지고 쓸 수 없을까? => 인트라넷
- IntraNet 도 TCP/IP Protocol 사용, 웹 브라우저 사용 등의 인터넷의 특성을 갖음
- But 해당 회사 사람 말고 다른 사람은 인터넷을 통해서 접속 불가 : 사내 네트워크

#### 3. ExtraNet 이란?

- 기업의 IntraNet 을 그 기업의 종업원 이외에도 협력 회사나 고객에게 사용할 수 있도록 한 것
- 내용은 IntraNet 과 거의 유사

---

## Part 02. 네트워크와 케이블 그리고 친구들

### Section 01. LAN (Local Area Network) 란?

#### 1. LAN (Local Area Network)

- "어느 한정된 공간에서 네트워크를 구성한다." 는 것
- 예를 들어, 한 사무실에서 컴퓨터 30대로 네트워크를 구성하는 경우 "사무실에 LAN을 구축한다." 라고 표현한다.
- 대비되는 단어로 WAN 존재

#### 2. WAN (Wide Area Network)

- "멀리 떨어진 지역을 서로 연결하는 경우" 에 사용
- 인터넷에 접속하는 것은 WAN 이라고 본다.

**Note** : 요즘 Networking 한다고 하면 주로 LAN 과 WAN 공존

> LAN 은 한정된 지역에서의 네트워크 구축, WAN 은 멀리 떨어진 곳과의 네트워크 구축

---

### Section 02. 이더넷은 인터넷의 친구?

#### 1. 이더넷(Ethernet) 이란?

- Networking의 한 방식으로, 네트워크를 만드는 방법 중 하나

- Ethernet 방식의 가장 큰 특징은 "CSMA/CD" Protocol 을 사용해서 통신한다는 것
- 우리나라에서 사용하는 Networking 방식의 거의 90% 이상
- 어떤 Networking 방식을 사용하느냐에 따라 랜카드부터 모든 네트워크 장비들을 다르게 구입해야함.

#### 2. CSMA/CD (Carrier Sense Multiple Access/Collision Detection) Protocol

> **! Note** : "CSMA/CD" 한마디로 표현 = "대충 알아서 눈치로 통신하자."

  1. Ethernet 환경에서 통신을 하려는 PC 나 서버는 현재 네트워크 상에 통신이 일어나고 있는지 확인

     - 우리 네트워크 자원을 쓰고 있는 PC 나 서버가 있는지를 확인함

     - Carrier Sense : Carrier (=네트워크 상에 나타나는 신호) 가 있는지를 감지
  2. If (carrier 감지됨) : 기다린다.
     Else : 자기 데이터를 네트워크 상에 실어서 보낸다.
  3. Ethernet 상에서 두 개 이상의 PC나 서버가 동시에 네트워크 상에 데이터를 실어 보내는 경우 Multiple Access (다중 접근) 이라고 한다.

     - 통신에서, 두 개의 장비가 데이터를 동시에 보내려다 부딪히는 경우 Collision 이 발생했다고 표현.
     - Collision Detection : 혹시 다른 PC 때문에 Collision 이 발생했는지를 점검하는 것
  4. Collision 이 발생되면 Random 한 시간 동안 기다린 다음 다시 데이터를 전송 시도
     - 15번을 했는데도 충돌이 나면 포기

> **! Note** 
>
> Ethernet 의 CSMA/CD Protocol 에서 Collision 발생은 자연스러운 일이지만, 너무 많은 충돌 발생 시 통신 자체가 불가능해지는 경우도 발생할 수 있다.

---

### Section 03. 그럼 토큰링(TokenRing) 은요?

#### TokenRing Networking

- 네트워크에서 토큰을 가진 PC 만 네트워크에 데이터를 실어 보낼 수 있는 Networking 방식
- 보통 하나의 네트워크에서 토큰 1개
- 데이터를 다 보내고 나면 바로 옆 PC에게 토큰 전달, 전송할 데이터가 없다면 토큰을 다시 옆 PC 로 전달
- 토큰링에서는 당연히 Collision 발생 없음
- 단점으로는 차례가 올 때까지 계속 기다려야 한다.
- IBM이 처음 개발했으며, 현재 역사의 뒤안길로 사라지는 추세.

---

### Section 04. UTP 케이블만이라도 제대로 알아볼까요?

통신 케이블은 네트워크 장비와 네트워크 장비를 연결할 때 반드시 필요하다.

- TP cable : Twisted-Pair, 두 가닥이 서로 꼬여 있는 cable

- UTP cable : Unshielded TP cable, 감싸지 않은 cable로 가장 많이 사용

- STP cable : Shielded TP cable, cable 주위를 절연체로 감싸서 만든 것

기존에 워낙 UTP로 구성된 네트워크가 많아 결국 UTP가 중심을 이루게 되었고, STP는 주로 TokenRing 쪽에 많이 쓰이고 있는 추세이다.

#### Cable Category

- Category 1 : 주로 전화망에 사용하는 용도
- Category 3 : 10 Base T 네트워크에 사용되는 케이블로, 예전에는 UTP 라고 하면 category 3 cable 을 의미할 정도로 많이 사용됨
- Category 4 : TokenRing network 에서 사용되는 케이블
- Category 5 : 기가비트용 케이블로 주로 사용되었으나 UTP cable 표준이 Category 5로 정해짐.

---

### Section 05. 케이블, 이 정도만 알면...

Ex] 10 Base T Cable

|            10            |                             Base                             |  T   |
| :----------------------: | :----------------------------------------------------------: | :--: |
| 속도를 의미, 10 = 10Mbps | Baseband 용 케이블을 의미한다<br> Baseband 는 디지털, Broadband 는 아날로그 방식 |      |

