# LAB Backup

## 기본 조건

### VM

- VM OS : CentOS 7.5
- Data Disk : 30 GiB 1개

### Back up

- 백업 주기 : 매주 새벽 1시

## 상세 조건

- `/filebackup` directory를 만들고 파일 업로드
- Data disk를 `/dbdata`에 마운트


## Work flow

1. VM 및 Data disk 생성
2. Data disk Partitioning & mount (`/dbdata`)
3. Azure 파일 공유 mount (`/filebackup`)
4. Azure Files에 파일 업로드, 백업, 파일 삭제 후 복원
5. `/dbdata` 디렉토리에 파일 생성 후 백업, 파일 삭제 후 디스크 복원
6. `/dbdata` 디렉토리에 파일 생성 후 백업, 파일 삭제 후 파일 복원


# Data disk partitioning

## 1. Disk 연결 후 `lsblk`를 사용해 disk가 잘 연결되었는지 확인한다.

<br>

```bash
lsblk -o NAME,HCTL,SIZE,MOUNTPOINT | grep -i "sd"
```

## 2. `parted`로 partitioning 진행

```bash
sudo parted /dev/sda --script mklabel gpt mkpart xfspart xfs 0% 100%
sudo mkfs.xfs /dev/sda1
sudo partprobe /dev/sda1
```

# Data disk mount

## 1. `mkdir`을 사용해 file system을 mount할 directory를 생성한다.

   - `data` 디렉토리 생성

       ```bash
       sudo mkdir /dbdata
       ```

## 2. `mount` 를 사용해 filesystem을 mount한다. 

다음은 `/dev/sdc1` partition을 mount point `/dbdata`에 mount 하는 예이다.

   ```bash
   sudo mount /dev/sda1 /dbdata
   ```

- 부팅 후 드라이브가 자동으로 다시 mount되도록 하려면 `/etc/fstab`파일에 추가 필요

- `/etc/fstab`에서 UUID(범용 고유 식별자)를 사용해 장치이름(`/dev/sdc1`)이 아니라 드라이브를 참조하는 것이 좋다.
- UUID를 확인하기 위해서는 다음 command를 사용한다

    ```bash
    sudo -i blkid
    ```

- text editor를 사용해 `fstab` 파일을 수정한다.

    ```bash
    sudo vi /etc/fstab
    ```

    `/etc/fstab` 파일 끝에 다음을 추가한다.

    ```bash
    UUID=33333333-3b3b-3c3c-3d3d-3e3e3e3e3e3e   /data   xfs   defaults   0   2
    ```

## 3. `/etc/fstab` 항목이 바른지 테스트한다.

   ```bash
   sudo mount -a
   ```

   위 명령의 결과, 오류 메시지가 발생하는 경우 `/etc/fstab` 파일에서 구문을 확인한다. 이 후 `mount` 명령을 실행해 file system이 탑재되었는지 확인한다.

   ```bash
   mount
   ```

# Azure File Share Mount

1. Storage account 생성
2. File Share 생성
3. Linux VM 에 File Share mount

<br>

# 파일 업로드 후 백업 진행

1. /dbdata, /filebackup 에 파일 업로드