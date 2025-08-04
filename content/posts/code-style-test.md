---
title: 코드 스타일 테스트
date: 2025-08-04T14:00:00+09:00
draft: true
lastmod: 2025-08-04T07:35:49.392Z
---

## 다양한 언어 코드 예제

### C# 예제
```csharp
using System;
using System.Text.Json;

public class Person
{
    public string Name { get; set; }
    public int Age { get; set; }
    
    // 메서드 예제
    public void Greet()
    {
        Console.WriteLine($"Hello, my name is {Name}!");
    }
}

// 직렬화 예제
var person = new Person { Name = "John", Age = 30 };
string json = JsonSerializer.Serialize(person);
```

### JavaScript 예제
```javascript
// 함수 선언
function calculateSum(a, b) {
    return a + b;
}

// 화살표 함수
const multiply = (x, y) => x * y;

// 클래스 정의
class Calculator {
    constructor() {
        this.result = 0;
    }
    
    add(value) {
        this.result += value;
        return this;
    }
}

// 비동기 처리
async function fetchData() {
    try {
        const response = await fetch('/api/data');
        const data = await response.json();
        console.log(data);
    } catch (error) {
        console.error('Error:', error);
    }
}
```

### Python 예제
```python
import json
from typing import List, Optional

class DataProcessor:
    """데이터 처리 클래스"""
    
    def __init__(self, name: str):
        self.name = name
        self.data: List[dict] = []
    
    def add_item(self, item: dict) -> None:
        """아이템 추가"""
        self.data.append(item)
    
    def process(self) -> Optional[str]:
        """데이터 처리 및 JSON 반환"""
        if not self.data:
            return None
        
        result = {
            'processor': self.name,
            'count': len(self.data),
            'items': self.data
        }
        
        return json.dumps(result, indent=2)

# 사용 예제
processor = DataProcessor("MainProcessor")
processor.add_item({'id': 1, 'value': 'test'})
print(processor.process())
```

### Go 예제
```go
package main

import (
    "encoding/json"
    "fmt"
    "log"
)

// Person 구조체 정의
type Person struct {
    Name  string `json:"name"`
    Age   int    `json:"age"`
    Email string `json:"email,omitempty"`
}

// 메서드 정의
func (p *Person) Greet() string {
    return fmt.Sprintf("Hello, I'm %s", p.Name)
}

func main() {
    // 구조체 생성
    person := Person{
        Name: "Alice",
        Age:  25,
    }
    
    // JSON 마샬링
    data, err := json.Marshal(person)
    if err != nil {
        log.Fatal(err)
    }
    
    fmt.Println(string(data))
    fmt.Println(person.Greet())
}
```

### SQL 예제
```sql
-- 테이블 생성
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 데이터 삽입
INSERT INTO users (username, email) 
VALUES ('john_doe', 'john@example.com');

-- 조인 쿼리
SELECT 
    u.username,
    u.email,
    COUNT(p.id) as post_count
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
WHERE u.created_at > '2024-01-01'
GROUP BY u.id, u.username, u.email
HAVING COUNT(p.id) > 5
ORDER BY post_count DESC;
```

### YAML 예제
```yaml
# Docker Compose 설정
version: '3.8'

services:
  web:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - DATABASE_URL=postgresql://user:pass@db:5432/mydb
    depends_on:
      - db
      - redis
  
  db:
    image: postgres:14
    volumes:
      - postgres_data:/var/lib/postgresql/data
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
      POSTGRES_DB: mydb

volumes:
  postgres_data:
```