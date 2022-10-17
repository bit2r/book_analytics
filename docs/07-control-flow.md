---
output: html_document
editor_options: 
  chunk_output_type: console
---




# 제어 흐름 {#r-control-flow}

종종 코딩할 때, 동작 흐름을 제어하고 싶을 때가 있다. 
한 조건 혹은 조건 집합이 만족될 때만 동작이 일어나게 설정함으로써 이런 작업을 수행한다. 
또 다른 방식으로, 특정 횟수만큼 동작이 일어나도록 설정할 수도 있다.

R에서 흐름을 제어하는 방식이 몇가지 있다. 
조건문에 대해서, 가장 흔히 사용되는 접근법이 루프 구성체(loop construct)다:



```r
# if
if (condition is true) {
  perform action
}

# if ... else
if (condition is true) {
  perform action
} else {  # that is, if the condition is false,
  perform alternative action
}
```

예를 들어, 변수 `x`가 특정값을 갖게 되면, 메시지를 출력하게 R에게 지시할 수도 있다:


```r
x <- 8

if (x >= 10) {
  print("x is greater than or equal to 10")
}

x
```

```
## [1] 8
```

콘솔에 `print` 출력문이 아무것도 출력시키지 않는데,
이유는 `x`가 10보다 크지 않기 때문이다.

10보다 작은 값에 대해 메시지를 출력시키려면, 
`else`문을 추가시키면 된다.


```r
x <- 8

if (x >= 10) {
  print("x is greater than or equal to 10")
} else {
  print("x is less than 10")
}
```

```
## [1] "x is less than 10"
```

`else if` 를 사용하면 다수 조건을 테스트할 수도 있다.


```r
x <- 8

if (x >= 10) {
  print("x is greater than or equal to 10")
} else if (x > 5) {
  print("x is greater than 5, but less than 10")
} else {
  print("x is less than 5")
}
```

```
## [1] "x is greater than 5, but less than 10"
```

**중요:** R이 `if()`문을 내부 조건을 평가할 때, 논리 요소 즉, `TRUE` 혹은 `FALSE`를 찾는다.
초심자에게 있어 이런 점이 두통을 유발할 수도 있다. 예를 들어:


```r
x  <-  4 == 3
if (x) {
  "4 equals 3"
} else {
  "4 does not equal 3"          
}
```

```
## [1] "4 does not equal 3"
```

`x` 벡터가 `FALSE`라서 `not equal` 메시지가 출력된다.


```r
x <- 4 == 3
x
```

```
## [1] FALSE
```

## 도전과제 1 {#r-control-flow-challenge-one}

`if` 문을 사용해서 `gapminder` 데이터셋에서 2002 년부터 어떤 레코드가 있는지 확인한 결과를
적절한 메시지로 출력하게 하자. 2012 년에 대해서도 동일한 작업을 수행한다.

> **도전과제 1에 대한 해답**
>
> 먼저 도전과제 1에 대한 해답을 살펴보자. `any()` 함수를 사용하지는 않는다.
> `gapminder$year` 벡터의 원소가 `2002`와 같은지 확인값을 갖는 논리 벡터를 생성시킨다:
>
> 
> ```r
> gapminder[(gapminder$year == 2002),]
> ```
>
> 그리고 나서, `2002`년과 대응되는 `gapminder` 데이터프레임 행의 숫자를 센다:
>
> 
> ```r
> rows2002_number <- nrow(gapminder[(gapminder$year == 2002),])
> ```
>
> 2002년에 대한 레코드 존재는 `rows2002_number` 숫자가 하나 혹은 그 이상인지 확인하는 것과 같다.
>
> 
> ```r
> rows2002_number >= 1
> ```
>
> 함께 담으면 다음과 같이 정리된다:
> 
> ```r
> if(nrow(gapminder[(gapminder$year == 2002),]) >= 1){
>    print("Record(s) for the year 2002 found.")
> }
> ```
>
> `any()` 함수로 상기 작업은 신속히 처리될 수 있다.
> 논리 조건을 다음과 같이 표현하여 작성할 수 있다:
>
> 
> ```r
> if(any(gapminder$year == 2002)){
>    print("Record(s) for the year 2002 found.")
> }
> ```
>


다음과 같은 경고 메시지가 나오는 사람이 있나요?



작성한 조건문이 하나 이상 논리 요소를 갖는 벡터를 평가하게 되면, `if` 함수는 쭉 실행되지만, 첫번째 요소에 대한 조건만 평가한다. 따라서, 조건문이 길이 1 이 되도록 확실히 할 필요가 있다.

::: {#r-control-flow-tips .rmdcaution}

**꿀팁: `any()` 와 `all()` 함수**

`any()` 함수는 벡터에 적어도 값 하나가 `TRUE` 가 되어야만 `TRUE` 값을 반환한다. 
그렇지 않은 경우 `FALSE` 값을 반환한다. 
이런 점은 `%in%` 연산자에 유사한 방식으로 적용된다. 
`all()` 함수는 명칭에서 나타나듯이, 
벡터에 모든 값이 `TRUE` 인 경우에만 `TRUE` 값을 반환한다.

:::

## 연산 반복 {#r-control-flow-for}

값을 담은 집합에 반복 작업을 수행할 때, 반복 순서가 중요하고, 
집합에 속한 원소 각각에 대해 동일한 연산을 수행하는 경우, `for()` 루프가 제격이다.
앞선 쉘 수업에서 `for()` 루프를 살펴봤다. 
`for()` 루프는 가장 유연하게 루프를 돌리는 연산이지만, 
유연성으로 인해 올바르게 사용하기도 가장 어렵다. 
반복작업 순서가 중요하지 않은 경우, `for()` 루프 사용을 회피한다: 
즉, 반복할 때마다 연산작업이 이전 반복작업 결과에 의존하는 경우.


`for()` 루프에 대한 기본 구조는 다음과 같다:


```r
for(iterator in set of values){
  do a thing
}
```

예를 들어:


```r
for(i in 1:10){
  print(i)
}
```

```
## [1] 1
## [1] 2
## [1] 3
## [1] 4
## [1] 5
## [1] 6
## [1] 7
## [1] 8
## [1] 9
## [1] 10
```

`1:10` 이 즉석에서 벡터를 생성된다; 
물론 다른 벡터도 반복시킬 수 있다.


두개 이상을 한번에 반복할 경우, 
또 다른 `for()` 루프를 `for()` 루프내부에 중첩시킬 수도 있다.



```r
for(i in 1:5){
  for(j in c('a', 'b', 'c', 'd', 'e')){
    print(paste(i,j))
  }
}
```

```
## [1] "1 a"
## [1] "1 b"
## [1] "1 c"
## [1] "1 d"
## [1] "1 e"
## [1] "2 a"
## [1] "2 b"
## [1] "2 c"
## [1] "2 d"
## [1] "2 e"
## [1] "3 a"
## [1] "3 b"
## [1] "3 c"
## [1] "3 d"
## [1] "3 e"
## [1] "4 a"
## [1] "4 b"
## [1] "4 c"
## [1] "4 d"
## [1] "4 e"
## [1] "5 a"
## [1] "5 b"
## [1] "5 c"
## [1] "5 d"
## [1] "5 e"
```

결과를 바로 출력하는 대신에, 루프 출력결과를 새로운 객체에 대입시킬 수도 있다.


```r
output_vector <- c()
for(i in 1:5){
  for(j in c('a', 'b', 'c', 'd', 'e')){
    temp_output <- paste(i, j)
    output_vector <- c(output_vector, temp_output)
  }
}
output_vector
```

```
##  [1] "1 a" "1 b" "1 c" "1 d" "1 e" "2 a" "2 b" "2 c" "2 d" "2 e" "3 a" "3 b"
## [13] "3 c" "3 d" "3 e" "4 a" "4 b" "4 c" "4 d" "4 e" "5 a" "5 b" "5 c" "5 d"
## [25] "5 e"
```

이러한 접근법은 유용할 수도 있지만, ‘실행결과를 키워나감’ (실행결과 객체를 점진적으로 키워나감) 이런 전략은 컴퓨터 계산 측면으로 보면 비효율적이다. 
그래서, 많은 값을 반복할 때는 회피한다.

::: {#r-control-flow-tips-grow .rmdcaution}

**꿀팁: 실행결과를 키워나가지 말라!**

초보자나 경험 많은 R 사용자 모두 저지르는 가장 큰 실수 중 하나가 실행결과 객체(벡터, 리스트, 행렬, 데이터프레임)를 루프를 돌리면서 키워나가는 것이다. 
컴퓨터는 이런 것을 처리하는데 매우 좋지 못하다. 
그래서 연산 속도가 급격히 늦어질 수 있다. 
미리 적절한 차원을 갖는 빈 연산결과 저장 객체를 정의하는 것이 훨씬 낫다. 
그래서, 상기처럼 실행결과를 저장할 행렬을 미리 알고 있다면, 
5 칼럼과 5 열로 구성된 빈 행렬를 생성하고 나서, 매번 반복을 돌릴 때마다 적절한 위치에 실행결과를 저장한다. 

- [고성능 R코드 작성과 성능비교](https://statkclee.github.io/parallel-r/perf-writing-efficient-code.html)
:::

더 좋은 방식은 값을 채워넣기 전에 (빈) 출력결과를 저장할 객체를 정의하는 것이다. 이번 예제의 경우, 더 복잡해 보이지만, 헐씬 더 효율적이다.


```r
output_matrix <- matrix(nrow=5, ncol=5)
j_vector <- c('a', 'b', 'c', 'd', 'e')
for(i in 1:5){
  for(j in 1:5){
    temp_j_value <- j_vector[j]
    temp_output <- paste(i, temp_j_value)
    output_matrix[i, j] <- temp_output
  }
}
output_vector2 <- as.vector(output_matrix)
output_vector2
```

```
##  [1] "1 a" "2 a" "3 a" "4 a" "5 a" "1 b" "2 b" "3 b" "4 b" "5 b" "1 c" "2 c"
## [13] "3 c" "4 c" "5 c" "1 d" "2 d" "3 d" "4 d" "5 d" "1 e" "2 e" "3 e" "4 e"
## [25] "5 e"
```

::: {#r-control-flow-while .rmdcaution}

**꿀팁: While 루프**

때로는 특정 조건이 만족될 때까지 연산작업을 반복할 필요도 있다. 
이런 작업은 `while()` 루프로 수행한다.


```r
while(this condition is true){
  do a thing
}
```

예제로, 0.1 보다 작은 난수가 나올 때까지 0 과 1 사이 균등 분포(`runif()` 함수)에서 난수를 뽑아내는 while 루프코드가 다음에 나와 있따.

```
z <- 1
while(z > 0.1){
  z <- runif(1)
  print(z)
}
```

`while()` 루프가 항상 적절한 것은 아니다. 조건이 절대 만족되지 않는 경우가 있어, 무한 루프에 빠지지 않도록 특별히 유의해야 된다.

:::


## 도전과제 2 {#r-control-flow-challenge-two}

`output_vector` 와 `output_vector2` 객체를 비교하라. 
두 객체는 동일한가? 만약 동일하지 않나면, 왜 동일하지 않을까? 
코드 마지막 블록을 변경해서 어떻게 `output_vector2` 를 `output_vector` 와 같도록 만들 수 있을까?

> **도전과제 2에 대한 해답**
>
> `all()` 함수를 사용해서 두 벡터가 동일한지 검사할 수 있다.
>
> 
> ```r
> all(output_vector == output_vector2)
> ```
>
> 하지만, `output_vector` 벡터 모든 요소가 `output_vector2`에 있기도 하다:
>
> 
> ```r
> all(output_vector %in% output_vector2)
> ```
>
> 바꿔서 검사해도 마찬가지다:
>
> 
> ```r
> all(output_vector2 %in% output_vector)
> ```
>
> 따라서 `output_vector` 와 `output_vector2` 벡터 원소가 단지 다른 순서로 정렬된 사실을 확인하게 된다.
> 원소 배치가 틀어진 이유는 `as.vector()` 함수 연산이 입력행렬을 칼럼을 기준으로 작업했기 때문이다.
> `output_matrix` 행렬을 살펴보면, 행기준으로 원소를 배열시키면 됨을 알 수 있다.
> 해법은 `output_matrix` 입력 행렬을 전치시키는 것이다. `t()` 함수 혹은 입력 원소 순서를 밖는 것을 통해서 원하는 작업을 완수할 수 있따.
> 
> 첫번째 해법은 원본 행렬을 
>
> 
> ```r
> output_vector2 <- as.vector(output_matrix)
> ```
>
> 다음과 같이 바꾸는 것이다.
>
> 
> ```r
> output_vector2 <- as.vector(t(output_matrix))
> ```
>
> 두번째 해법은 다읔과 같이 행렬 원소 위치를 
>
> 
> ```r
> output_matrix[i, j] <- temp_output
> ```
>
> 다음과 같이 바꾸는 것이다.
>
> 
> ```r
> output_matrix[j, i] <- temp_output
> ```

## 도전과제 3 {#r-control-flow-challenge-three}


`gapminder` 데이터 루프를 대륙별로 돌리는 스크립트를 작성한다. 
그리고 나서 평균 기대수명이 50년 보다 길거나 짧은지 결과를 출력한다.

> **도전과제 3에 대한 해답**
>
> **1 단계**: 대륙 벡터(`continent`)에서 유일무이한 값을 모두 추출한다.
> 
> ```r
> gapminder <- read.csv("data/gapminder_data.csv")
> unique(gapminder$continent)
> ```
>
> **2 단계**: 각 대륙별로 루프를 돌리는데 `gapminder` 데이터에 `subset()` 함수로 각 대륙별 부분 데이터셋을 추출하고 평균 기대수명을 계산한다.
> 상기 작업과정을 다음과 같이 구현할 수 있다.
>
> 1. 'continent' 유일무이한 값 각각에 대해 루프를 돌린다.
> 2. 각 대륙별 부분 데이터셋별로 계산된 기대수명값을 임시 변수에 저장시킨다.(`tmp`)
> 3. 평균 기대수명을 계산해서 출력결과를 화면에 뿌려주는 형태로 사용자에게 반환시킨다: 
>
> 
> ```r
> for( iContinent in unique(gapminder$continent) ){
>    tmp <- mean(subset(gapminder, continent==iContinent)$lifeExp)
>    cat("Average Life Expectancy in", iContinent, "is", tmp, "\n")
>    rm(tmp)
> }
> ```
>
> **3 단계**: 평균 기대수명이 50보다 적거나 큰 경우만 결과를 출력시킨다. 이런 경우,
> 결과를 출력시키기 전에 `if` 조건을 추가한다.
> `if` 조건을 출력전에 추가해서 산출된 평균 기대수명이 기준치보다 높거나 낮은지를 평가하고 
> 해당 조건에 맞춰 결과를 출력시킨다.
> 앞서 작성한 코드에 (3)을 반영하여 코드를 수정한다:
>
> 3a. 계산된 평균 기대수명 기준치(50년)보다 적은 경우 
> 평균 기대수명이 기준치보다 낮은 대륙을 반환시킨다. 그렇지 않은 경우도,
> 평균 기대수명이 기준치보다 높은 대륙을 반환시키는 코드를 작성한다;
>
> 
> ```r
> thresholdValue <- 50
> 
> for( iContinent in unique(gapminder$continent) ){
>    tmp <- mean(subset(gapminder, continent==iContinent)$lifeExp)
>    
>    if(tmp < thresholdValue){
>        cat("Average Life Expectancy in", iContinent, "is less than", thresholdValue, "\n")
>    }
>    else{
>        cat("Average Life Expectancy in", iContinent, "is greater than", thresholdValue, "\n")
>         } # end if else condition
>    rm(tmp)
>    } # end for loop
> ```

## 도전과제 4 {#r-control-flow-challenge-four}

도전과제 3 에서 나온 스크립트를 변경해서 각 국각별로 루프를 돌린다. 
이번에는 예상수명이 50 년보다 짧은지, 50 년에서 70 년 사이, 70 년 이상인지 결과를 출력한다.

> **도전과제 4에 대한 해답**
>
> 도전과제 해답을 변경하여 `lowerThreshold`, `upperThreshold` 두개 기준값을 추가시키고,
> `if-else`문을 확장시킨다.
>
> 
> ```r
>  lowerThreshold <- 50
>  upperThreshold <- 70
>  
> for( iCountry in unique(gapminder$country) ){
>     tmp <- mean(subset(gapminder, country==iCountry)$lifeExp)
>     
>     if(tmp < lowerThreshold){
>         cat("Average Life Expectancy in", iCountry, "is less than", lowerThreshold, "\n")
>     }
>     else if(tmp > lowerThreshold && tmp < upperThreshold){
>         cat("Average Life Expectancy in", iCountry, "is between", lowerThreshold, "and", upperThreshold, "\n")
>     }
>     else{
>         cat("Average Life Expectancy in", iCountry, "is greater than", upperThreshold, "\n")
>     }
>     rm(tmp)
> }
>  ```
> 
> ## 도전과제 5 - 고급 {#r-control-flow-challenge-five}
> 
> `gapminder` 데이터셋에서 각 국가별로 루프를 돌리는 스크립트를 작성한다. 
> 국가명이 ‘B’ 로 시작하는지 테스트하고, 
> 만약 평균 기대수명이 50 년보다 작은 경우 선그래프로 시간에 대해 기대수명을 그래프를 그린다.
> 
> **도전과제 5에 대한 해답**
> 
> 유닉스 쉘 학습에서 소개된 `grep` 명령어를 사용해서 "B"로 시작하는 국가를 찾는다.
> 먼저 "B"로 시작하는 국가를 찾는 방법을 이해하자.
> 유닉스 쉘 학습에 소개된 내용을 따라 다음과 같이 작성하고 싶을 것이다. 
> ```
> 
> ```r
> grep("^B", unique(gapminder$country))
> ```
>
> 하지만, 상기 명령어를 평가하게 되면, "B"으로 시작되는 요인변수 `country`의 인덱스만 반환시킨다. 
> 해당 값을 얻으려면, `grep` 명령어 내부에 `value=TRUE` 옵션을 추가시키면 된다:
>
> 
> ```r
> grep("^B", unique(gapminder$country), value=TRUE)
> ```
>
> `candidateCountries` 변수에 "B"로 시작되는 국가를 저장시킨다. 
> 그리고 나서, 변수에 포함된 원소 각각을 루프 돌린다.
> 루프 내부에, 각 국가별로 평균 기대수명을 평가한다.
> 만약 평균 기대수명이 50보다 낮은 경우 연도별 평균 기대수명이 변하는 것을 `Base` 플롯으로 시각화한다:
>
> 
> ```r
> thresholdValue <- 50
> candidateCountries <- grep("^B", unique(gapminder$country), value=TRUE)
> 
> for( iCountry in candidateCountries){
>     tmp <- mean(subset(gapminder, country==iCountry)$lifeExp)
>     
>     if(tmp < thresholdValue){
>         cat("Average Life Expectancy in", iCountry, "is less than", thresholdValue, "plotting life expectancy graph... \n")
>         
>         with(subset(gapminder, country==iCountry),
>                 plot(year,lifeExp,
>                      type="o",
>                      main = paste("Life Expectancy in", iCountry, "over time"),
>                      ylab = "Life Expectancy",
>                      xlab = "Year"
>                    ) # end plot
>               ) # end with
>     } # end for loop
>     rm(tmp)
>  }
>  ```
> ```
