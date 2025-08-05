---
title: "다이어그램과 플로우차트"
date: 2019-03-06
draft: true
description: "Congo에서 Mermaid 사용 가이드"
summary: "Mermaid를 사용하여 기사에 다이어그램과 플로우차트를 쉽게 추가할 수 있습니다."
tags: ["mermaid", "예시", "다이어그램", "숏코드"]
coverAlt: "Photo by Lorem Picsum from https://picsum.photos"
---

Congo에서는 `mermaid` 숏코드를 사용하여 Mermaid 다이어그램을 지원합니다. 다이어그램 마크업을 숏코드로 간단히 감싸면 됩니다. Congo는 설정된 `colorScheme` 매개변수에 맞춰 Mermaid 다이어그램 테마를 자동으로 적용합니다.


아래 예시들은 [공식 Mermaid 문서](https://mermaid-js.github.io/mermaid/)에서 가져온 일부입니다. 마크업을 보려면 GitHub에서 [페이지 소스](https://raw.githubusercontent.com/jpanther/congo/dev/exampleSite/content/samples/diagrams-flowcharts/index.md)를 확인할 수도 있습니다.

## 플로우차트

{{< mermaid >}}
graph TD
A[Christmas] -->|Get money| B(Go shopping)
B --> C{Let me think}
B --> G[/Another/]
C ==>|One| D[Laptop]
C -->|Two| E[iPhone]
C -->|Three| F[Car]
subgraph Section
C
D
E
F
G
end
{{< /mermaid >}}

## Sequence diagram

{{< mermaid >}}
sequenceDiagram
autonumber
par Action 1
Alice->>John: Hello John, how are you?
and Action 2
Alice->>Bob: Hello Bob, how are you?
end
Alice->>+John: Hello John, how are you?
Alice->>+John: John, can you hear me?
John-->>-Alice: Hi Alice, I can hear you!
Note right of John: John is perceptive
John-->>-Alice: I feel great!
loop Every minute
John-->Alice: Great!
end
{{< /mermaid >}}

## Class diagram

{{< mermaid >}}
classDiagram
Animal "1" <|-- Duck
Animal <|-- Fish
Animal <--o Zebra
Animal : +int age
Animal : +String gender
Animal: +isMammal()
Animal: +mate()
class Duck{
+String beakColor
+swim()
+quack()
}
class Fish{
-int sizeInFeet
-canEat()
}
class Zebra{
+bool is_wild
+run()
}
{{< /mermaid >}}

## Entity relationship diagram

{{< mermaid >}}
erDiagram
CUSTOMER }|..|{ DELIVERY-ADDRESS : has
CUSTOMER ||--o{ ORDER : places
CUSTOMER ||--o{ INVOICE : "liable for"
DELIVERY-ADDRESS ||--o{ ORDER : receives
INVOICE ||--|{ ORDER : covers
ORDER ||--|{ ORDER-ITEM : includes
PRODUCT-CATEGORY ||--|{ PRODUCT : contains
PRODUCT ||--o{ ORDER-ITEM : "ordered in"
{{< /mermaid >}}
