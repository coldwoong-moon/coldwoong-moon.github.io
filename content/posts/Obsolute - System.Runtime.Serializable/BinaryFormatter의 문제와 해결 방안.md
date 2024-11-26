---
title: BinaryFormatter의 문제와 해결 방안
date: 2024-10-28T08:04:14+09:00
draft: true
showDateUpdated: true
created: 2024-10-24
modified: 2024-10-28T08:04:14+09:00
tags: 
---

![](../file-20241024-154357698.jpg)
> [MS .NET 8.0](https://learn.microsoft.com/ko-kr/dotnet/standard/serialization/binaryformatter-security-guide)에서의 BinaryFormatter 제거 권고사항

## 들어가며

안녕하세요. 오늘은 업무 중 만나게 된 Regacy 코드에서 발견한 `BinaryFormatter` 에 대해 이야기해보려고 합니다.



## BinaryFormatter 를 제거해야 하는 이유

### Serialize 의 공통적 문제
직렬화하여 생성한 파일에 외부 클래스를 포함한다면 해당 클래스에 의존성이 생기게 됩니다.


## 마무리

저는 개발 관점에서 우선 바라보았기에 BinaryFormatter 는 코드에 대한 의존도가 지나치게 높기 때문에 `안정성`이 부족하다고 판단했습니다.
한국어로 작성된 글의 설명에 '이 글은 한국어(Serializer Assembly)로 작성되었고 홍길동(Data Assembly) 작가의 소설책(User Class)이다.’ 라는 설명이 있어야만 읽을 수 있는 느낌(클래스 내부의 필드 등도 일치해야 함)

읽어주셔서 감사합니다.

항상 건강하시고 행복한 하루 보내세요!

<!--### 관련된 문서-->


