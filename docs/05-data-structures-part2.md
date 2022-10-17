---
output: html_document
editor_options: 
  chunk_output_type: console
---




# 데이터프레임 탐색 {#r-dataframe}


현 시점에서 모든 것을 살펴봤다: 마지막 수업에서, R의 모든 기본 자료형과 자료구조에 대한 여행을 마쳤다.
여러분이 수행하는 모든 작업은 이러한 도구를 조작하는 것이 된다.
하지만, 거의 대부분 쇼의 진정한 스타는 데이터프레임이다 - csv 파일에 정보를 불러와서 생성시킨 테이블.
이번 수업에서 데이터프레임으로 작업하는 방법에 대해 좀더 학습할 것이다.


## 행과 열을 추가 {#r-dataframe-add}

데이터프레임의 칼럼은 벡터라는 것을 배웠다.
따라서, 데이터는 칼럼에서 자료형의 일관성을 유지해야 한다.
이를테면, 칼럼을 새로 추가하려면 벡터를 새로 만들어서 시작한다:



```r
library(tidyverse)

cats <- read_csv("data/feline-data.csv")
age <- c(2, 3, 5)
cats
```

```
## # A tibble: 3 x 3
##   coat   weight likes_string
##   <chr>   <dbl>        <dbl>
## 1 calico    2.1            1
## 2 black     5              0
## 3 tabby     3.2            1
```

`age`를 칼럼으로 다음과 같이 추가한다:



```r
cbind(cats, age)
```

```
##     coat weight likes_string age
## 1 calico    2.1            1   2
## 2  black    5.0            0   3
## 3  tabby    3.2            1   5
```

데이터프레임의 행의 갯수와 다른 갯수를 갖는 `age` 벡터를 추가하게되면 추가되지 않고 오류가 발생됨에 주의한다:


```r
age <- c(2, 3, 5, 12)
cbind(cats, age)
```

```
## Error in data.frame(..., check.names = FALSE): arguments imply differing number of rows: 3, 4
```

```r
age <- c(2, 3)
cbind(cats, age)
```

```
## Error in data.frame(..., check.names = FALSE): arguments imply differing number of rows: 3, 2
```

왜 정상동작이 되지 않을까? 
R은 테이블의 모든 행마다, 신규 칼럼에서도 원소 하나가 있길 원한다:


```r
nrow(cats)
```

```
## [1] 3
```

```r
length(age)
```

```
## [1] 2
```

그래서, 정상 동작하려면 `nrow(cats)` = `length(age)`이 되어야 한다.
`cats` 콘텐츠를 새로운 데이터프레임으로 덮어써보자.


```r
age <- c(2, 3, 5)
cats <- cbind(cats, age)
```

이제 행을 추가하면 어떻게 될까?
이미 데이터프레임의 행이 리스트라는 사실을 알고 있다:


```r
newRow <- list("tortoiseshell", 3.3, TRUE, 9)
cats <- rbind(cats, newRow)
```

## 요인 (Factors) {#r-dataframe-factor}

살펴볼 것이 하나더 있다: `요인(factor)`에서 각기 다른 값을 `수준(level)`이라고 한다.
요인형 "coat" 변수는 수준이 3으로 구성된다: "black", "calico", "tabby". 
R은 세가지 수준 중 하나와 매칭되는 값만 받아들인다.
완전 새로운 값을 추가하게 되면, 추가되는 신규 값은 `NA`가 된다.

경고 메시지를 통해서 *coat* 요인변수에 "tortoiseshell" 값을 추가하는데 성공하지 못했다고 알려준다.
하지만, 3.3 (숫자형), TRUE (논리형), and 9 (숫자형) 모두 *weight*, *likes_string*, *age* 변수에 
성공적으로 추가된다. 왜냐하면 변수가 요인형이 아니라서 그렇다.
"tortoiseshell"을 *coat* 요인변수에 성공적으로 추가하려면, 요인의 수준(level)로 "tortoiseshell"을 추가하면 된다:


```r
levels(cats$coat)
```

```
## NULL
```

```r
levels(cats$coat) <- c(levels(cats$coat), "tortoiseshell")
cats <- rbind(cats, list("tortoiseshell", 3.3, TRUE, 9))
```

대안으로, 요인형 벡터를 문자형 벡터로 변환시키면 된다;
요인변수의 범주를 잃게 되지만, 요인 수준을 조심스럽게 다룰 필요없이, 
칼럼에 추가하고자 하는 임의 단어를 추가하면 된다:


```r
str(cats)
```

```
## 'data.frame':	5 obs. of  4 variables:
##  $ coat        : Factor w/ 1 level "tortoiseshell": NA NA NA 1 1
##  $ weight      : num  2.1 5 3.2 3.3 3.3
##  $ likes_string: num  1 0 1 1 1
##  $ age         : num  2 3 5 9 9
```

```r
cats$coat <- as.character(cats$coat)
str(cats)
```

```
## 'data.frame':	5 obs. of  4 variables:
##  $ coat        : chr  NA NA NA "tortoiseshell" ...
##  $ weight      : num  2.1 5 3.2 3.3 3.3
##  $ likes_string: num  1 0 1 1 1
##  $ age         : num  2 3 5 9 9
```

## 도전과제 1 {#r-dataframe-challenge-one}

1. `cats$age` 벡터에 7을 곱해서 `human_age` 벡터를 생성하자.
2. `human_age`를 요인형으로 변환시키자.
3. `as.numeric()` 함수를 사용해서 `human_age` 벡털르 다시 숫자형 벡터로 변환시킨다.
   이제 7로 나눠서 원래 고양이 나이로 되돌리자. 무슨 일이 생겼는지 설명하자.
   
> **도전과제 1에 대한 해답**
>
> 1. `human_age <- cats$age * 7`
> 2. `human_age <- factor(human_age)`. `as.factor(human_age)` works just as well.
> 3. `as.numeric(human_age)`을 실행하면 `1 2 3 4 4`이 된다.
>
> 왜냐하면 요인형 변수는 정수형(여기서 1:4)으로 자료를 저장하기 때문이다. 
> 정수 라벨과 연관된 값은 여기서 28, 35, 56, 63이다.
> 요인형 변수를 숫자형 벡터로 변환시키면 라벨이 아니라 그 밑단의 정수를 반환시킨다.
> 원래 숫자를 원하는 경우, `human_age`를 문자형 벡터로 변환시키고 나서 숫자형 벡터로 변환시키면 된다.(왜 이방식은 정장 동작할까?) 
> 실수로 숫자만 담긴 칼럼 어딘가 문자가 포함된 csv 파일로 작업할 때 이런 일이 실제로 종종 일어난다.
> 데이터를 불러 읽어올 때 `stringsAsFactors=FALSE` 설정을 잊지말자.


## 행 제거 {#r-dataframe-remove}

이제 데이터프레임에 행과 열을 추가하는 방법을 알게 되었다 - 하지만, 
데이터프레임에 "tortoiseshell" 고양이를 처음으로 추가하면서, 우연히 
쓰레기 행을 추가시켰다:


```r
cats
```

```
##            coat weight likes_string age
## 1          <NA>    2.1            1   2
## 2          <NA>    5.0            0   3
## 3          <NA>    3.2            1   5
## 4 tortoiseshell    3.3            1   9
## 5 tortoiseshell    3.3            1   9
```

데이터프레임에 문제가 되는 행을 마이너스해서 빼자:



```r
cats[-4, ]
```

```
##            coat weight likes_string age
## 1          <NA>    2.1            1   2
## 2          <NA>    5.0            0   3
## 3          <NA>    3.2            1   5
## 5 tortoiseshell    3.3            1   9
```

`-4,` 다음에 아무것도 적시하지 않아서 4번째 행 전체를 제거함에 주목한다.

주목: 벡터 내부에 행 다수를 넣어 한번에 행을 제거할 수도 있다: `cats[c(-4,-5), ]`

대안으로, `NA` 값을 갖는 모든 행을 제거시킨다:


```r
na.omit(cats)
```

```
##            coat weight likes_string age
## 4 tortoiseshell    3.3            1   9
## 5 tortoiseshell    3.3            1   9
```

출력결과를 `cats`에 다시 대입하여 변경사항이 데이터프레임이 영구히 남도록 조치한다:


```r
cats <- na.omit(cats)
```

## 칼럼 제거 {#r-dataframe-column-remove}

데이터프레임의 칼럼도 제거할 수 있다.
"age" 칼럼을 제거하고자 한다면 어떨까?
변수명과 변수 인덱스, 두가지 방식으로 칼럼을 제거할 수 있다.


```r
cats[,-4]
```

```
##            coat weight likes_string
## 4 tortoiseshell    3.3            1
## 5 tortoiseshell    3.3            1
```

`,-4` 앞에 아무것도 없는 것에 주목한다. 모든 행을 간직한다는 의미를 갖는다.

대안으로, 색인명을 사용해서 컬럼을 제거할 수도 있다.


```r
drop <- names(cats) %in% c("age")
cats[,!drop]
```

```
##            coat weight likes_string
## 4 tortoiseshell    3.3            1
## 5 tortoiseshell    3.3            1
```

## dataframe 덧붙이기 {#r-dataframe-rbind}

데이터프레임(dataframe)에 데이터를 추가시킬 때 기억할 것은 **칼럼은 벡터, 행은 리스트**라는 사실이다.
`rbind()` 함수를 사용해서 데이터프레임 두개를 본드로 붙이듯이 결합시킬 수 있다:


```r
cats <- rbind(cats, cats)
cats
```

```
##             coat weight likes_string age
## 4  tortoiseshell    3.3            1   9
## 5  tortoiseshell    3.3            1   9
## 41 tortoiseshell    3.3            1   9
## 51 tortoiseshell    3.3            1   9
```

행명칭(rownames)이 불필요하게 복잡해져, 행명칭을 제거하면,
자동적으로 R이 순차적으로 행명칭을 부여시킨다.


```r
rownames(cats) <- NULL
cats
```

```
##            coat weight likes_string age
## 1 tortoiseshell    3.3            1   9
## 2 tortoiseshell    3.3            1   9
## 3 tortoiseshell    3.3            1   9
## 4 tortoiseshell    3.3            1   9
```

## 도전과제 2 {#r-dataframe-challenge-two}

다음 구문을 사용해서 R 내부에서 직접 데이터프레임을 새로 만들 수 있다:


```r
df <- data.frame(id = c("a", "b", "c"),
                 x = 1:3,
                 y = c(TRUE, TRUE, FALSE),
                 stringsAsFactors = FALSE)
```

다음 정보를 갖는 데이터프레임을 직접 제작해 보자:

- 이름(first name)
- 성(last name)
- 좋아하는 숫자

`rbind`를 사용해서 옆사람을 항목에 추가한다.
마지막으로 `cbind()`함수를 사용해서 "지금이 커피시간인가요?"라는 질문의 답을 칼럼으로 추가한다. 

> **도전과제 2에 대한 해답**
>
> 
> ```r
> df <- data.frame(first = c("Grace"),
>                  last = c("Hopper"),
>                  lucky_number = c(0),
>                  stringsAsFactors = FALSE)
> df <- rbind(df, list("Marie", "Curie", 238) )
> df <- cbind(df, coffeetime = c(TRUE,TRUE))
> ```

## 현실적인 예제 {#r-dataframe-practice}

지금까지 고양이 데이털르 가지고 데이터프레임 조작에 대한 기본적인 사항을 살펴봤다.
이제 학습한 기술을 사용해서 좀더 현실적인 데이터셋을 다뤄보자.
앞에서 다운로드 받은 `gapminder` 데이터셋을 불러오자:


```r
gapminder <- read.csv("data/gapminder_data.csv")
```

::: {#r-dataframe-tips .rmdcaution}

**기타 팁**

* 흔히 맞닥드리는 또다른 유형의 파일이 탭구분자를 갖는 파일(.tsv)이다. 탭을 구분자로 명세하는데, `"\\t"`을 사용하고, `read.delim()` 함수로 불러 읽어온다.
* 파일을 `download.file()` 함수를 사용해서 인터넷으로부터 직접 본인 컴퓨터 폴더로 다운로드할 수 있다.
  `read.csv()` 함수를 실행해서 다운로드 받은 파일을 읽어온다. 예를 들어,
  

```r
download.file("https://raw.githubusercontent.com/swcarpentry/r-novice-gapminder/gh-pages/_episodes_rmd/data/gapminder_data.csv", 
               destfile = "data/gapminder_data.csv")
gapminder <- read.csv("data/gapminder_data.csv")
```

* 대안으로, `read.csv()` 함수 내부에 파일 경로를 웹주소를 치환해서 인터넷에서 직접 파일을 불러올 수도 있다.
  이런 경우 로컬 컴퓨터에 csv 파일이 전혀 저장되지 않았다는 점을 주의한다. 예를 들어,
  

```r
gapminder <- read.csv("https://raw.githubusercontent.com/swcarpentry/r-novice-gapminder/gh-pages/_episodes_rmd/data/gapminder_data.csv")
```

* [readxl](https://cran.r-project.org/web/packages/readxl/index.html) 팩키지를 사용해서,
  엑셀 스프레드쉬트를 평범한 텍스트로 변환하지 않고 직접 불러올 수도 있다.

:::


`gapminder` 데이터셋을 좀더 살펴보자; 항상 가장 먼저 해야되는 작업은 
`str` 명령어로 데이터가 어떻게 생겼는지 확인하는 것이다:


```r
str(gapminder)
```

```
## 'data.frame':	1704 obs. of  6 variables:
##  $ country  : chr  "Afghanistan" "Afghanistan" "Afghanistan" "Afghanistan" ...
##  $ year     : int  1952 1957 1962 1967 1972 1977 1982 1987 1992 1997 ...
##  $ pop      : num  8425333 9240934 10267083 11537966 13079460 ...
##  $ continent: chr  "Asia" "Asia" "Asia" "Asia" ...
##  $ lifeExp  : num  28.8 30.3 32 34 36.1 ...
##  $ gdpPercap: num  779 821 853 836 740 ...
```

`typeof()` 함수로 데이터프레임 칼럼 각각을 면밀히 조사할 수도 있다:


```r
typeof(gapminder$year)
```

```
## [1] "integer"
```

```r
typeof(gapminder$country)
```

```
## [1] "character"
```

```r
str(gapminder$country)
```

```
##  chr [1:1704] "Afghanistan" "Afghanistan" "Afghanistan" "Afghanistan" ...
```

데이터프레임 차원에 정보를 얻어낼 수도 있다;
`str(gapminder)` 실행결과 `gapminder` 데이터프레임에 관측점 1704, 변수 6개가 있음을 상기한다.
다음 코드 실행결과는 무엇일까? 그리고 왜 그렇게 되는가?


```r
length(gapminder)
```

```
## [1] 6
```

공정한 추측은 아마도 데이터프레임 길이가 행의 길이(1704)라고 보는 것이다.
하지만, 이번에는 다르다; 데이터프레임은 **벡터와 요인으로 구성된 리스트**라는 사실이다:


```r
typeof(gapminder)
```

```
## [1] "list"
```

`length()` 함수는 6을 제시하는데, 이유는 `gapminder`가 6개 칼럼을 갖는 리스트로 만들어졌기 때문이다.
데이터셋에서 행과 열 숫자를 얻는데 다음 함수를 던져보자:


```r
nrow(gapminder)
```

```
## [1] 1704
```

```r
ncol(gapminder)
```

```
## [1] 6
```

혹은 한번에 보려면:


```r
dim(gapminder)
```

```
## [1] 1704    6
```

또한, 모든 칼럼의 칼럼명이 무엇인지 파악하고자 하면 다음과 같이 질문을 던진다:



```r
colnames(gapminder)
```

```
## [1] "country"   "year"      "pop"       "continent" "lifeExp"   "gdpPercap"
```

현 단계에서, R이 제시하는 구조가 우리의 직관 혹은 예상과 부합되는지 묻어보는 것이 중요하다;
각 칼럼에 대한 기본 자료형은 이해가 되는가?
만약 납득이 가지 않는다면, 후속 작업에서 나쁜 놀라운 사실로 전환되기 전에 문제를 해결해야 한다.
문제를 해결하는데, R이 데이터를 이해하는 방법과 데이터를 기록할 때 *엄격한 일관성(strict consistency)*의 
중요성에 관해 학습한 것을 동원한다.

자료형과 자료구조가 타당해 보이게 되면, 데이터를 제대로 파고들어갈 시간이 되었다.
`gapminder` 데이터 처음 몇줄을 살펴보자:


```r
head(gapminder)
```

```
##       country year      pop continent lifeExp gdpPercap
## 1 Afghanistan 1952  8425333      Asia    28.8       779
## 2 Afghanistan 1957  9240934      Asia    30.3       821
## 3 Afghanistan 1962 10267083      Asia    32.0       853
## 4 Afghanistan 1967 11537966      Asia    34.0       836
## 5 Afghanistan 1972 13079460      Asia    36.1       740
## 6 Afghanistan 1977 14880372      Asia    38.4       786
```


## 도전과제 3 {#r-dataframe-challenge-three}

데이터 마지막 몇줄, 중간 몇줄을 점검하는 것도 좋은 습관이다. 그런데 어떻게 점검할 수 있을까?
중간 몇줄을 찾아보는 것이 너무 어렵지는 않지만, 임의로 몇줄을 추출할 수도 있다. 어떻게 할 수 있을까요?

> ** 도전과제 3에 대한 해답
> 마지막 몇줄을 점검하려면, R에 내장된 함수가 있어서 상대적으로 간단하다:
> 
> ```
> tail(gapminder)
> tail(gapminder, n = 15)
> ```
> 
> 데이터가 온전한지(혹은 관점에 따라 데이터가 온전하지 않은지)를 점검하는데 몇줄을 추출할 수 있을까요?
>
> **꿀팁: 몇가지 방법이 존재한다.**
>
> 중첩함수(또다른 함수에 인자로 전달되는 함수)를 사용한 해법도 있다. 
> 새로운 개념처럼 들리지만, 사실 이미 사용하고 있다.
> my_dataframe[rows, cols]  명령어는 데이터프레임을 화면에 뿌려준다.
> 데이터프레임에 행이 얼마나 많은지 알지 못하는데 어떻게 마지막 행을 뽑아낼 수 있을까?
> R에 내장된 함수가 있다.
> (의사) 난수를 얻어보는 것은 어떨가? R은 난수추출 함수도 갖추고 있다.
>
> ```
> gapminder[sample(nrow(gapminder), 5), ]
> ```


분석결과를 재현가능하게 확실하게 만들려면,
코드를 스크립트 파일에 저장해서 나중에 다시 볼 수 있어야 한다.

## 도전과제 4 {#r-dataframe-challenge-four}

`file -> new file -> R script`로 가서,
`gapminder` 데이터셋을 불러오는 R 스크립틀르 작성한다.
`scripts/` 디렉토리에 저장하고 버전제어 시스템에도 추가한다.
인자로 파일 경로명을 사용해서 `source()` 함수를 사용해서 스크립트를 실행하라.
(혹은 RStudio "source" 버튼을 누른다)

> **도전과제 4에 대한 해답**
> `scripts/load-gapminder.R` 파일에 담긴 내용물은 다음과 같다:
>
> 
> ```r
> download.file("https://raw.githubusercontent.com/swcarpentry/r-novice-gapminder/gh-pages/_episodes_rmd/data/gapminder_data.csv",
>                destfile = "data/gapminder_data.csv")
> gapminder <- read.csv(file = "data/gapminder_data.csv")
> ```
>
> 스크립트를 실행시키면 데이터를 `gapminder` 변수에 적재시킨다:
>
> 
> ```r
> source(file = "scripts/load-gapminder.R")
> ```

## 도전과제 5 {#r-dataframe-challenge-five}

`str(gapminder)` 출력결과를 다시 불러오자;
이번에는 `gapminder` 데이터에 대해 `str()` 함수가 출력하는 모든 것이 의미하는 바를 설명한다.
지금까지 학습한 요인, 리스트와 벡터 뿐만 아니라, `colnames()`, `dim()`와 같은 함수도 동원한다.
이해하지 못한 부분이 있다면, 주면 동료와 상의한다!

> **도전과제 5에 대한 해답**
>
> `gapminder` 객체는 다음 칼럼을 갖는 데이터프레임이다.
> - `country` `continent` 변수는 요인형 벡터
> - `year` 변수는 정수형 벡터
> - `pop`, `lifeExp`, `gdpPercap` 변수는 숫자형 벡터
>

