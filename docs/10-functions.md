---
output: html_document
editor_options: 
  chunk_output_type: console
---




# 함수 설명 {#r-function}

분석할 데이터셋이 하나라면, 파일을 엑셀같은 스프레드쉬트로 불러와서
간단한 통계량을 도식화하는 것이 아마도 훨씬 빠를 것이다.
하지만, `gapminder` 데이터는 주기적으로 갱신되서,
나중에 새로운 정보를 뽑아와서 분석작업을 다시 실행할 수도 있다.
또한, 미래 특정 시점에 다양한 곳에서 유사한 데이터를 얻어올 수도 있다.

이번 수업에서, 단일 명령어로 여러가지 연산작업을 반복하는
함수 작성방법을 학습할 것이다.

::: {#function-definition .rmdcaution}

**함수란 무엇인가?**

함수는 연속된 연산작업을 모아 전체를 하나로 만들고, 
향후 사용을 위해 보관된다. 함수는 다음 기능을 제공한다:

* 기억할 수 있고 나중에 호출할 수 있는 명칭
* 개별적인 연산을 기억할 필요에서 해방
* 사전에 정의된 입력과 예상되는 출력
* 더 큰 프로그래밍 환경에 풍부한 연계성

프로그래밍 언어 대부분의 기본 구성요소로서,
사용자 정의 함수는 어떠한 단일 추상화 못지 않는 중요한 "프로그래밍"으로 간주된다.
함수를 작성할 수 있다면, 여러분은 컴퓨터 프로그래머다:

:::

## 함수 정의하기 {#r-funciton-definition}

새로운 R 스크립트 파일을 `functions/` 디렉토리에 `functions-lesson.R` 
이름으로 저장하고 편집기에서 연다.



```r
my_sum <- function(a, b) {
  the_sum <- a + b
  return(the_sum)
}
```

화씨온도에서 캘빈온도로 변환하는 `fahr_to_kelvin()` 함수를 정의한다:



```r
fahr_to_kelvin <- function(temp) {
  kelvin <- ((temp - 32) * (5 / 9)) + 273.15
  return(kelvin)
}
```

`function` 출력을 대입하는 `fahr_to_kelvin()` 함수를 정의한다.
인자 명칭 리스트는 괄호 안에 담겨진다.
다음으로 함수 [몸통부문]({{ page.root }}/reference.html#function-body)
(함수를 실행할 때 실행되는 문장)이 
괄호(`{}`) 내부에 담겨진다.
몸통부문 문장은 보통 공백 2 개로 들여쓰기한다.
들여쓰면, 코드 가독성이 높아지지만, 코드 동작에는 영향을 끼치지 않는다.

함수 생성을 요리책 저작하는 것처럼 생각하면 도움이된다.
먼저, 함수가 필요로 하는 "식재료(ingredient)"를 정의한다.
온도 변환기 함수에서, 함수에 사용할 식재료는 하나만 필요하다: "temp". 
식재료를 쭉 나열한 후에, 식재료로 무엇을 할지 기술한다;
이번 경우에, 식재료를 받아 일련의 수학 연산작업을 수행한다.

함수를 호출할 때, 함수에 전달되는 값이 변수에 대입된다.
그래서, 함수 내부에서 전달되는 값을 사용할 수 있다.
함수 내부에서 [반환문(return)]({{ page.root }}/reference.html#return-statement)을
사용해서 호출한 쪽에 결과를 되돌려준다.

::: {#function-tips .rmdcaution}

**꿀팁:**

R에만 있는 유일무이한 기능 하나가 반환문 `return`이 반듯이 필요하지 않다는 점이다.
R은 자동적으로 함수 몸통부문 마지막 줄에 있는 어떤 변수나 반환시킨다.
하지만 명확성을 위해서, 명시적으로 반환문 `return`을 정의한다.

:::


함수를 실행해보자.
본인이 작성한 사용자 정의 함수 호출은 여타 다른 함수 호출과 차이가 없다:



```r
# 빙점
fahr_to_kelvin(32)
```

```
## [1] 273
```


```r
# 끓는 점
fahr_to_kelvin(212)
```

```
## [1] 373
```

## 도전과제 1 {#r-function-challenge-one}

`kelvin_to_celsius()` 함수를 작성해서 캘빈온도를 받아 섭씨온도를 반환한다.
**힌트:** 캘빈온도를 섭씨온도로 전환하려면, 273.15 을 뺀다.

> **도전과제 1에 대한 해답**
>
> `kelvin_to_celsius()` 함수를 작성해서 캘빈온도를 받아 섭씨온도를 반환한다.
>
> 
> ```r
> kelvin_to_celsius <- function(temp) {
>  celsius <- temp - 273.15
>  return(celsius)
> }
> ```

## 함수 결합 {#r-function-composition}

함수의 진정한 힘은 원하는 효과를 얻어 내는데 함수를 섞고, 매칭하고, 결합해서 
더 큰 덩어리로 구현함에 있다.

화씨 온도에서 캘빈 온도로, 갤빈 온도에서 섭씨 온도로 온도를 전환하는 함수 두개를 정의한다:


```r
fahr_to_kelvin <- function(temp) {
  kelvin <- ((temp - 32) * (5 / 9)) + 273.15
  return(kelvin)
}

kelvin_to_celsius <- function(temp) {
  celsius <- temp - 273.15
  return(celsius)
}
```

## 도전과제 2 {#r-function-challenge-two}

바로 위에 정의된 함수 두개를 재사용해서 화씨온도에서 바로 섭씨온도로 
변환하는 함수를 정의한다.
(혹은, 본인이 원하면 자신이 직접 작성한 함수를 사용한다.)

> **도전과제 2에 대한 해답**
>
> 바로 위에 정의된 함수 두개를 재사용해서 화씨온도에서 바로 섭씨온도로 
> 변환하는 함수를 정의한다.
>
>
> 
> ```r
> fahr_to_celsius <- function(temp) {
>   temp_k <- fahr_to_kelvin(temp)
>   result <- kelvin_to_celsius(temp_k)
>   return(result)
> }
> ```

## 방어적 프로그래밍 {#r-function-defensive}

R코드를 재사용가능하고 모듈화 되도록 만드는데 함수 작성이 효율적인 방법을 제공한다는 점에서 이제야 
참진가를 알게 되었다. 따라서, 함수가 의도된 방식으로 동작하도록 확실히 하는 것도 매우 중요하다.
함수 매개변수(인자) 검사는 **방어적 프로그래밍(defensive programming)** 개념과 연관되어 있다.
방어적 프로그래밍은 자주 조건을 검사하고, 무언가 잘못되면 오류를 던지도록 장려한다.
이러한 검사를 단언문(assertion statement)라고 부른다. 왜냐하면 다음으로 넘어가기 전에 
조건이 `TRUE` 사실로 단언해야 되기 때문이다.
이러한 특성이 디버깅을 더 수월하게 하는데 이유는 오류가 최초 생겨난 곳에 대해 더 나은 아이디어를 
제시해 주기 때문이다.


### `stopifnot()` 조건 검사 {#r-function-stopifnot}

화씨 온도를 켈빈 온도로 변환하는데 사용되는 자체 제작 함수 `fahr_to_kelvin()`을 
다시 살펴보면서 시작해보자. 함수가 다음과 같이 정의되었다:


```r
fahr_to_kelvin <- function(temp) {
  kelvin <- ((temp - 32) * (5 / 9)) + 273.15
  return(kelvin)
}
```

함수가 의도한 대로 동작하기 위해서, `temp` 인자는 숫자형(`numeric`) 값이 되어야 한다;
그렇지 않은 경우, 온도를 변환하는 수학 연산 작업이 정상적으로 수행되지 않게 된다.
오류를 생성시키는데, `stop()` 함수를 사용한다.
예를 들어, `temp` 인자는 숫자형(`numeric`) 벡터가 되어야 하는데, 
`if` 문으로 조건을 검사해서 조건이 위반되면 오류를 던진다.
이를 반영하여 다음과 같이 함수 기능을 강화시킬 수 있다:


```r
fahr_to_kelvin <- function(temp) {
  if (!is.numeric(temp)) {
    stop("temp must be a numeric vector.")
  }
  kelvin <- ((temp - 32) * (5 / 9)) + 273.15
  return(kelvin)
}
```

검사할 다수 조건과 인자가 있게 되면, 이 모두를 검사하는 코드가 많이 필요하게 된다.
다행히, `stopifnot()` 편의 함수가 R에서 지원된다.
`TRUE` 참으로 평가되어야 하는 요구사항을 쭉 나열한다; `FALSE` 거짓인 것이 하나 
발견되면 `stopifnot()` 함수는 오류를 던진다.
이러한 조건을 나열하는 것이 함수에 대한 부가 문서로서 부차적인 역할을 담당도 한다.

`fahr_to_kelvin()` 함수의 입력값을 검사하는 단언문을 추가해서 
`stopifnot()` 함수로 방어적 프로그래밍을 시도해보자.

다음을 단언문으로 확인하자; `temp` 인자가 숫자 벡터다. 다음과 같이 코드를 작성하자:


```r
fahr_to_kelvin <- function(temp) {
  stopifnot(is.numeric(temp))
  kelvin <- ((temp - 32) * (5 / 9)) + 273.15
  return(kelvin)
}
```

적절한 입력이 제시되면 정상적으로 동작한다.


```r
# 빙점
fahr_to_kelvin(temp = 32)
```

```
## [1] 273
```

부적절한 입력이 제시되면 즉시 실패한다.


```r
# 숫자형 대신에 문자가 주어짐.
fahr_to_kelvin(temp = as.factor(32))
```

```
## Error in fahr_to_kelvin(temp = as.factor(32)): is.numeric(temp) is not TRUE
```

## 도전과제 3 {#r-function-challenge-three}

방어적 프로그래밍을 사용해서, `temp` 인자를 부적절하게 제시하게 되면
`fahr_to_celsius()` 함수가 오류를 즉시 던지도록 작성한다.

> **도전과제 3에 대한 해답**
>
> `stopifnot()` 함수에 명시적으로 호출을 추가해서 앞서 정의한 함수를 확장시킨다.
> `fahr_to_celsius()` 함수는 다른 두 함수를 조합한 것이라서,
> 두번째 함수에도 검사를 추가하는 것은 중복이 된다.
>
> 
> ```r
> fahr_to_celsius <- function(temp) {
>   stopifnot(is.numeric(temp))
>   temp_k <- fahr_to_kelvin(temp)
>   result <- kelvin_to_celsius(temp_k)
>   return(result)
> }
> ```

## 함수조합 {#r-function-composition-more}

이제 데이터셋에서 한 국가에 대한 국내총생산(GDP)를 계산하는 함수를 작성한다:


```r
# 데이터셋을 인자로 받아, 1인당 GDP 칼럼과 인구수 칼럼을 곱한다.
calcGDP <- function(dat) {
  gdp <- dat$pop * dat$gdpPercap
  return(gdp)
}
```

`function` 출력을 대입하는 `calcGDP()` 함수를 정의한다.
인자 명칭 리스트는 괄호 안에 담겨진다.
다음으로 함수 몸통부문
(함수를 실행할 때 실행되는 문장)이 
괄호(`{}`) 내부에 담겨진다.

몸통부문 문장을 공백 2 개로 들여쓰기한다.
들여쓰면, 코드 가독성이 높아지지만, 코드 동작에는 영향을 끼치지 않는다.

함수를 호출할 때, 함수에 전달되는 값이 인자에 대입된다.
전달되는 값은 함수 몸통 내부에서 변수가 된다.

함수 내부에서, `return()` 함수를 사용해서 결과를 함수밖으로 배출한다.
반환 `return()` 함수는 선택옵션이다:
R은 자동으로 함수 마지막 줄에 실행되는 어떤 명령어든 결과를 반환한다.



```r
calcGDP(head(gapminder))
```

```
## [1] 6.57e+09 7.59e+09 8.76e+09 9.65e+09 9.68e+09 1.17e+10
```

그다지 유용한 정보는 아니다.
인자를 일부 추가해서 연도별, 국가별 GDP를 추출한다.



```r
# 데이터셋을 인자로 받아, 1인당 GDP 칼럼과 인구수 칼럼을 곱한다.
calcGDP <- function(dat, year=NULL, country=NULL) {
  if(!is.null(year)) {
    dat <- dat[dat$year %in% year, ]
  }
  if (!is.null(country)) {
    dat <- dat[dat$country %in% country,]
  }
  gdp <- dat$pop * dat$gdpPercap

  new <- cbind(dat, gdp=gdp)
  return(new)
}
```

별도 R 스크립트 파일에 상기 함수를 작성했다면(좋은 아이디어!), `source()` 함수를 
사용해서 R 세션에 함수를 올려 적재할 수 있다:



```r
source("functions/functions-lesson.R")
```

이제 함수에 상당히 많은 일을 하고 있네요.
쉬운 말로 풀어쓰면, 연도 `year` 인자가 비어있지 않는다면,
함수가 전달된 연도 정보로 부분집합 데이터를 생성하고 나서,
국가 `country` 인자가 비어있지 않는다면,
함수가 전달된 국가 정보로 부분집합 데이터를 생성한다.
그리고 나서, 연도와 국가 인자에서 추출된 부분집합에 대해 
GDP를 계산한다.
그리고 나서, 함수가 GDP를 신규 칼럼으로 추가해서 부분집합으로 뽑아낸 데이터셋에서
추가하고 최종 결과로 반환한다.
숫자 벡터로 쭉 뽑혀진 것보다 출력결과가 훨씬 더 유용한 정보를 제공함을 알 수 있다.

연도를 인자로 명세할 때 어떤 일이 발생하는지 살펴보자:


```r
head(calcGDP(gapminder, year=2007))
```

```
##        country year      pop continent lifeExp gdpPercap      gdp
## 12 Afghanistan 2007 31889923      Asia    43.8       975 3.11e+10
## 24     Albania 2007  3600523    Europe    76.4      5937 2.14e+10
## 36     Algeria 2007 33333216    Africa    72.3      6223 2.07e+11
## 48      Angola 2007 12420476    Africa    42.7      4797 5.96e+10
## 60   Argentina 2007 40301927  Americas    75.3     12779 5.15e+11
## 72   Australia 2007 20434176   Oceania    81.2     34435 7.04e+11
```

혹은 특정 국가를 인자로 전달하면 어떻게 되는지 살펴보자:


```r
calcGDP(gapminder, country="Australia")
```

```
##      country year      pop continent lifeExp gdpPercap      gdp
## 61 Australia 1952  8691212   Oceania    69.1     10040 8.73e+10
## 62 Australia 1957  9712569   Oceania    70.3     10950 1.06e+11
## 63 Australia 1962 10794968   Oceania    70.9     12217 1.32e+11
## 64 Australia 1967 11872264   Oceania    71.1     14526 1.72e+11
## 65 Australia 1972 13177000   Oceania    71.9     16789 2.21e+11
## 66 Australia 1977 14074100   Oceania    73.5     18334 2.58e+11
## 67 Australia 1982 15184200   Oceania    74.7     19477 2.96e+11
## 68 Australia 1987 16257249   Oceania    76.3     21889 3.56e+11
## 69 Australia 1992 17481977   Oceania    77.6     23425 4.10e+11
## 70 Australia 1997 18565243   Oceania    78.8     26998 5.01e+11
## 71 Australia 2002 19546792   Oceania    80.4     30688 6.00e+11
## 72 Australia 2007 20434176   Oceania    81.2     34435 7.04e+11
```

혹은, 연도와 국가를 모두 인자로 전달하면 어떻게 되는지 살펴보자:


```r
calcGDP(gapminder, year=2007, country="Australia")
```

```
##      country year      pop continent lifeExp gdpPercap      gdp
## 72 Australia 2007 20434176   Oceania    81.2     34435 7.04e+11
```

함수 몸통부문을 살펴본다:


```r
calcGDP <- function(dat, year=NULL, country=NULL) {
```

위에서 인자 두개 `year`, `country`를 추가했다.
함수 정의부에서 *기본디폴트 인자*를 모두 `=` 연산자를 사용해서 `NULL`로 설정했다.
이것이 의미하는 바는 사용자가 달리 인자를 설정하지 않는다면,
각 인자에 `NULL` 값을 인자로 넘기게 된다.


```r
  if(!is.null(year)) {
    dat <- dat[dat$year %in% year, ]
  }
  if (!is.null(country)) {
    dat <- dat[dat$country %in% country,]
  }
```

여기서, 각기 추가되는 인자가 `null` 로 설정되었는지 검사한다.
`null` 이 아닌 경우, `null`이 아닌 인자로 부분집합 데이터로 뽑아내려고
`dat`에 저장된 데이터셋을 덮어쓴다.

추후에 좀더 유연하게 함수를 작성할 예정이다.
따라서, GDP를 다음 질문에 대해 답할 수 있다:

 * 전체 데이터셋;
 * 단일 연도;
 * 단일 국가;
 * 단일 연도와 단일국가 조합.

대신에 `%in%` 연산자를 사용해서, 여러 연도와 국가를 인자에 넘길 수 있다.

::: {#r-function-pass-by-value .rmdcaution}

**꿀팁: 값에 의한 전달**

R에 함수는 거의 항상 데이터 사본을 생성해서 함수 몸통 내부에서  
연산 작업을 수행한다.
함수 내부 `dat` 데이터를 변경할 때, 
첫 인자로 전달한 원본 데이터가 아닌 `dat`에 저장된 `gapminder` 데이터셋
사본을 조작하는 것이다.

이를 "값에 의한 전달(pass-by-value)" 라고 부르며,
코드 작성을 훨씬 더 안전하게 한다:
함수 몸통부문 내부에서 어떤 변경을 하든, 함수 몸통부문에 한정된 것이라는 것을
항상 확실히 할 수 있다.
:::

::: {#r-function-scope .rmdcaution}

**꿀팁: 함수 유효범위(Function scope)**

또한가지 중요한 개념이 유효범위(scoping)다: 
함수 몸통부문 내부에서 생성하거나 변경한 어떤 변수(혹은 함수!)는 
함수 실행 기간동안만 존재한다.
`calcGDP` 함수를 호출할 때, 변수 `dat`,
`gdp`, `new`는 함수 몸통 내부에서만 존재한다.
설사 인터랙티브 세션에서 동일한 명칭을 갖는 변수가 있더라도,
함수가 시행될 때, 어떤 방식으로도 변경되지 않는다.

:::


```r
  gdp <- dat$pop * dat$gdpPercap
  new <- cbind(dat, gdp=gdp)
  return(new)
}
```

마지막으로, 신규 부분집합 데이터셋에 GDP를 계산하고,
신규 데이터프레임을 생성하고  동일한 명칭을 갖는 칼럼을 추가한다.
즉, 나중에 함수를 호출할 때, 반환된 GDP 값에 대한 맥락을 찾아볼 수 있다는 것이다.
앞서 숫자 벡터보다 이런 점에서 훨씬 더 낫다.

## 도전과제 4 {#r-function-challenge-four}

1987년 뉴질랜드 GPD를 계산하도록 GDP 함수를 테스트한다. 
1952년 뉴질랜드 GDP와 얼마나 차이날까?

> **도전과제 4에 대한 해답**
>
> 
> ```r
>   calcGDP(gapminder, year = c(1952, 1987), country = "New Zealand")
> ```
> 
> 1987년 뉴질랜드 GDP: 65050008703
>
> 1952년 뉴질랜드 GDP: 21058193787

## 도전과제 5 {#r-function-challenge-five}


`paste` 함수를 사용해서 텍스트를 결합할 수 있다, 즉:


```r
best_practice <- c("Write", "programs", "for", "people", "not", "computers")
paste(best_practice, collapse=" ")
```

```
## [1] "Write programs for people not computers"
```

`text` 와 `wrapper`라는 벡터 인자 두개를 받는 `fence`라는 함수를 작성한다.
 함수는 `wrapper`로 둘러싼 텍스트를 출력한다:
 

```r
fence(text=best_practice, wrapper="***")
```

*주목:* `paste` 함수는 `sep` 라는 인자를 갖는데,
`sep` 인자는 텍스트 사이 구분자를 명세한다.
기본디폴트 설정은 공백이다: " ". `paste0` 함수에 대한 기본디폴트 설정은 공백이 없음이다:"".

> **도전과제 5에 대한 해답**
>
> `text` 와 `wrapper`라는 벡터 인자 두개를 받는 `fence`라는 함수를 작성한다.
>  함수는 `wrapper`로 둘러싼 텍스트를 출력한다:
>
> 
> ```r
> fence <- function(text, wrapper){
>   text <- c(wrapper, text, wrapper)
>   result <- paste(text, collapse = " ")
>   return(result)
> }
> best_practice <- c("Write", "programs", "for", "people", "not", "computers")
> fence(text=best_practice, wrapper="***")
> ```
> 
> ```
> ## [1] "*** Write programs for people not computers ***"
> ```


::: {#r-function-manual .rmdcaution}

**꿀팁:**

더 복잡한 연산작업을 수행할 때, 정말 잘 활용될 수 있는 R에만 있는 유일무이한 기능이 있다.
이러한 고급 개념으로 무장한 함수는 작성하지 않을 것이다.
향후, R로 함수를 작성하는데 무리가 없다면,
[R Language Manual][man]과 Hadley Wickham 저서  [Advanced R Programming][adv-r]
책에 포함된 [환경][chapter]을 참조한다.
R은 프레임(frame) 대신에 "환경(environment)"을 용어로 사용한다.

:::

[man]: http://cran.r-project.org/doc/manuals/r-release/R-lang.html#Environment-objects
[chapter]: http://adv-r.had.co.nz/Environments.html
[adv-r]: http://adv-r.had.co.nz/

::: {#r-function-testing .rmdcaution}

**꿀팁: 테스트와 문서화**

함수를 테스트하고 문서화하는 것 모두 중요하다:
문서화를 하게 되면 여러분과 다른 독자가 작성된 함수 목적과
사용법을 이해하는데 도움이 된다.

작성된 함수가 생각한 대로 실제로 동작하는지 확실히 하는 것도 중요하다.
처음 시작할 때, 작업흐름은 아마도 다음과 같다:

 1. 함수를 작성한다.
 2. 함수 일부에 동작을 문서화하는 주석을 단다.
 3. 소스 파일에 적재해서 불러온다.
 4. 콘솔에서 예상한 대로 동작을 확인하는 실험을 한다.
 5. 필요한 버그를 제거한다.
 6. 깔끔하게 하고, 상기 과정을 반복한다.
 
함수에 대한 공식 문서는 별도 `.Rd` 파일에 작성되는데,
도움말 파일에서 보게 되는 문서로 변환된다.

[roxygen2][] 팩키지는 R 프로그래머가 함수 코드와 함께 문서를 
작성하게 돕고, 이 파일을 처리하게 되면 적절한 `.Rd` 파일로 떨군다.
더 복잡한 R 프로젝트 코드를 작성할 때, 
문서를 작성하는 공식적인 방법으로 전환하면 된다. 
공식 자동화 테스트는 [testthat][] 팩키지를 사용해서 작성된다.
:::

[roxygen2]: http://cran.r-project.org/web/packages/roxygen2/vignettes/rd.html
[testthat]: http://r-pkgs.had.co.nz/tests.html


