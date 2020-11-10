# Blob

## Blob type에 대한 이해

> Reference : [Block blob, append blob 및 page blob 이해](https://docs.microsoft.com/ko-kr/rest/api/storageservices/understanding-block-blobs--append-blobs--and-page-blobs)

### Block Blob
- 한 block에 몇 kb인지?
- Block이 떨어져 있을 수도 있고 붙어 있을 수도 있음
- 많은 양의 데이터를 효율적으로 업로드 하는데 최적화되어 있음
- Block blob은 block으로 구성되며, 최대 5만 block을 포함 가능
- 최대 block 및 blob 크기
  |Service version|최대 block 크기(put block 통해)|최대 blob 크기(put block 통해)|단일 쓰기 작업을 통한 최대 blob 크기(put block 통해)|
  |:---:|:---:|:---:|:---:|
  |version 2019-12-12 이상|4000 MiB|약 190.7 TiB(4000 MiB X 5만 block)| 5000 MiB|
  |version 2016-05-31 ~ 2019-07-07|100 MiB|약 4.75 TiB(100 MiB X 5만 block)|256 MiB|
  |2016-05-31 이전 version|4 MiB|약 195 GiB(4 MiB X 5만 block)|64 MiB|

### Page Blob
- Block이 서로 붙어 있는 형태인 Page 형태
- Random access

> **Random Access**
> 
>     Memory의 Address (번지)만 지시하면 어느 부분에서도 즉시 data를 읽어낼 수 있는 호출 방식
> 
> - 일정량의 데이터마다 record number를 붙여 어느 번호의 데이터를 디스크의 어느 부분에 기억시켜 놓았는지에 대해 번지표를 작성해 데이터의 위치를 빠르게 파악
> - 대응되는 개념으로 Sequential access가 있으며 Sequential access는 맨 앞부터 차례로 탐색해야 한다.
> 
> **English Wiki** : [Random Access](https://en.wikipedia.org/wiki/Random_access)
> ```
>  Random access (more precisely and more generally called direct access) is the ability to access an arbitrary(임의의) element of a sequence in equal time or any datum ((하나의)자료[정보,데이터]) from a population of addressable elements roughly as easily and efficiently as any other, no matter how many elements may be in the set. In computer science it is typically contrasted to sequential access which requires data to be retrieved in the order it was stored.```

