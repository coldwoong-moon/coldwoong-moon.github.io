---
title: "차트"
date: 2019-03-06
draft: true
description: "Congo에서 Chart.js 사용 가이드"
summary: "Congo는 강력한 차트와 데이터 시각화를 위해 Chart.js를 포함합니다."
tags: ["차트", "예시", "그래프", "숏코드"]
---

Congo는 `chart` 숏코드를 사용하여 Chart.js를 지원합니다. 숏코드 안에 차트 마크업을 간단히 감싸면 됩니다. Congo는 설정된 `colorScheme` 매개변수에 맞춰 차트 테마를 자동으로 적용하지만, 일반적인 Chart.js 문법을 사용하여 색상을 사용자 정의할 수 있습니다.


아래 예시들은 [공식 Chart.js 문서](https://www.chartjs.org/docs/latest/samples)에서 가져온 일부입니다. 마크업을 보려면 GitHub에서 [페이지 소스](https://raw.githubusercontent.com/jpanther/congo/dev/exampleSite/content/samples/charts/index.md)를 확인할 수도 있습니다.

## 막대 차트

<!-- prettier-ignore-start -->
{{< chart >}}
type: 'bar',
data: {
  labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July'],
  datasets: [{
    label: 'My First Dataset',
    data: [65, 59, 80, 81, 56, 55, 40],
    backgroundColor: [
      'rgba(255, 99, 132, 0.2)',
      'rgba(255, 159, 64, 0.2)',
      'rgba(255, 205, 86, 0.2)',
      'rgba(75, 192, 192, 0.2)',
      'rgba(54, 162, 235, 0.2)',
      'rgba(153, 102, 255, 0.2)',
      'rgba(201, 203, 207, 0.2)'
    ],
    borderColor: [
      'rgb(255, 99, 132)',
      'rgb(255, 159, 64)',
      'rgb(255, 205, 86)',
      'rgb(75, 192, 192)',
      'rgb(54, 162, 235)',
      'rgb(153, 102, 255)',
      'rgb(201, 203, 207)'
    ],
    borderWidth: 1
  }]
}
{{< /chart >}}
<!-- prettier-ignore-end -->

## Line chart

<!-- prettier-ignore-start -->
{{< chart >}}
type: 'line',
data: {
  labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July'],
  datasets: [{
    label: 'My First Dataset',
    data: [65, 59, 80, 81, 56, 55, 40],
    tension: 0.2
  }]
}
{{< /chart >}}
<!-- prettier-ignore-end -->

## Doughnut chart

<!-- prettier-ignore-start -->
{{< chart >}}
type: 'doughnut',
data: {
  labels: ['Red', 'Blue', 'Yellow'],
  datasets: [{
    label: 'My First Dataset',
    data: [300, 50, 100],
    backgroundColor: [
      'rgba(255, 99, 132, 0.7)',
      'rgba(54, 162, 235, 0.7)',
      'rgba(255, 205, 86, 0.7)'
    ],
    borderWidth: 0,
    hoverOffset: 4
  }]
}
{{< /chart >}}
<!-- prettier-ignore-end -->
