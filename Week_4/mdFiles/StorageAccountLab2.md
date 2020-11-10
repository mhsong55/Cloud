# Azure Storage Account Lab2 - Blob 사용 실전

# CDN 통합

# 상황

- 전세계에서 접속하는 쇼핑몰 개설
- CDN 사용
- Azure CDN, Blob 사용해 CDN 구성

# 조건

1. CDN 사업자 : Microsoft
2. CDN 원본 : Storage Account Blob
3. URL :
   - 의류 : ~/clothes
   - 건강기능식품 : ~/healthfuncfood

# 문제 해결

## 1. Container 생성

- 사진을 업로드할 두 개의 컨테이너 혹은 하나의 컨테이너를 생성
- 컨테이너는 계층 구조로 구성 가능하므로 원하는 방법 선택

  - `clothes`, `healthfuncfood` container 두 개를 생성하고 각각 옷 이미지, 홍삼 이미지 넣어둠

## 2. Storage account 에서 cdn profile, cdn endpoint 생성

- cdn profile, cdn endpoint를 각각 resource로 생성해서 연결시켜도 됨
- Storage Account에서 생성하면 자동으로 연결됨
- cdn 생성 시 가격 정책에 대해 조사할 것

**Reference**

1. [Azure Storage Explorer](https://azure.microsoft.com/ko-kr/features/storage-explorer/)
2. [계층 구조 만들기](https://stackoverflow.com/questions/2619007/microsoft-azure-how-to-create-sub-directory-in-a-blob-container)

## 3. URL Access test

- Web browser를 사용해 Container 내 blob 의 image에 접근이 가능하면 성공
- 지역별 접근에 따른 pop routing 공부