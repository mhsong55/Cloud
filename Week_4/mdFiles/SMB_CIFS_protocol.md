# SMB & CIFS Protocol

SMB (Server Message Block)은 원래 IBM에서 개발되었으며, 이 후 마이크로 소프트가 가장 일반적으로 사용되는 버전에 상당한 수정을 진행했다.

SMB 는 원래 NetBIOS/NetBEUI API에서 작도아도록 개발되었다. Windows 2000 이후, SMB는 TCP 포트 139 (NetBIOS) 대신 TCP 445 (CIFS) 포트를 사용하도록 변경되었다. Sun Micro Systems 가 WebNFS 라는 것을 발표했을 무렵, 마이크로 소프트는 SMB를 CIFS (Common Internet File system)라는 이름으로 변경하면서 Simbolic link, Hard Link, 더 큰 파일 지원 등의 기능을 추가했다. 전송에서도 더 이상 NetBIOS에 의존하지 않고 TCP 445 포트를 통해 직접 할 수 있도록 수정했다.

## What is CIFS/SMB?

CIFS (Commin Internet File System)는 SMB로도 잘 알려져 있는 네트워크 프로토콜로, Local Area Network (LAN)에서 파일을 공유하는데 가장 일반적으로 사용된다. Client/Server Application protocol이기 때문에 TCP/IP를 통한 원격 서비스와 Client 프로그램의 요청을 가능하게 한다. CIFS는 컴퓨터 사용자가 기업의 인트라넷이나 인터넷을 통해 파일을 공유하는 표준이라고 할 수 있다. Microsoft의 Open, Cross-platform Server Message Block (SMB) protocol의 향상된 버전이며, Windows 2000의 native file share protocol이다.

> 쉽게 생각하면, 우리가 흔히 PC의 윈도우 탐색기에서 마우스 오른쪽 버튼을 눌러 속성 탭에 공유로 해당 폴더를 공유하고, 다른 PC에서 네트워크 드라이브로 연결하여 상대방 PC의 Storage를 원격 접속할 때 사용하는 것이 바로 이 CIFS protocol이다.

## OVERVIEW

CIFS는 다양한 목적을 가진 Network File System protocol로 Client에게 과닐와 동시에 Server system에서 host되는 file 및 directory access를 제공한다. 또한 인쇄를 위한 access와 process 간 통신 서비스 등을 지원한다.

CIFS는 Client로부터의 Packet을 Server에 보내는 일을 주로 하게 된다. Packet은 보통 몇 가지 기본적인 요청들로 파일 열기, 닫기 또는 읽는 일을 하는데, Server는 Packet을 받고 request가 정상적인지 확인하며 Client가 적절한 파일 권한을 가지고 있는지 입증하고 마지막으로 Request를 실행해 response packet을 Client에 return한다.

CIFS는 Server system에 host된 프린터, 파일들을 여러 client가 동시에 공유할 수 있다. 이는 자원을 효과적으로 사용할 수 있도록 하고 통합 관리에 용이하다.

## CIFS/SMB Transports

OSI 모델에 있어 CIFS는 Application/Presentation layer에서 설명되는 꽤 High-level의 network protocol이다. 이 말은 CIFS가 Transport layer에서는 다른 Protocol에 의지함을 의미한다. 안정적인 전송을 위해 가장 일반적으로 사용되는 것은 NetBIOS over TCP (NBT)이다. 주로 다른 protocol들이 transport layer에서 사용되어 왔는데, 인터넷의 인기가 증가하면서 NBT가 사실상 표준으로 자리잡았다.