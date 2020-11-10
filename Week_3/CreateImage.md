# Image 생성하기

- Managed image 1 개당 최대 20개의 동시 배포 지원

- 동일한 managed image에서 20개 초과하는 VM 동시에 생성 시, 단일 VHD의 Storage 성능 제한으로 Provisioning 시간 초과 가능
    - 따라서 20 개가 넘는 VM을 동시에 만드려면 20 개의 동시 VM 배포 마다 복제본 1개로 구성된 Shared Image Gallery를 사용

## Sysprep을 사용해 Windows VM 일반화

Sysprep은 모든 개인 계정 및 보안 정보를 제거한 다음 Image로 사용할 컴퓨터를 준비한다.