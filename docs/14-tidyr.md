---
output: html_document
editor_options: 
  chunk_output_type: console
---




#  `tidyr` 솜씨있게 조작 {#r-tidyr}

과학연구원들은 흔히 'wide' 형식에서 'long' 형식으로 혹은 역으로 데이터를 솜씨있게 조작해야 한다. 
'long' 형식은 다음과 같이 정의된다:

- 각 칼럼이 변수.
- 각 행이 관측점

'long' 형식에서, 일반적으로 관측된 변수에 대해서 칼럼이 하나만 있고,
다른 칼럼은 ID 변수다.

'wide' 형식에서, 각 행은 흔히 관측점(site/subject/patient)이며, 
동일한 자료형을 담고 있는 다수 관측변수를 갖게 된다. 
시간이 경과함에 따라 반복되는 관측점이거나, 다수 변수의 관측점(혹은 둘이 혼합된 사례)일 수 있다. 
데이터 입력이 더 단순하거나 일부 다른 응용사례에서 'wide' 형식을 선호할 수 있다. 
하지만, `R` 함수 다수는 'long'형식을 가정하고 설계되었다. 
이번 학습을 통해서 원래 데이터 형식에 관계없이 데이터를 효율적으로 변환하는 방식을 학습한다. 

![](assets/images/r/14-tidyr-fig1.png){width=100%}


데이터 형식은 주로 가독성에 영향을 준다. 
사람에게, 'wide' 형식이 좀더 직관적인데, 이유는 데이터 형상으로 인해 화면에 더 많은 데이터를 볼 수 있기 때문이다. 
하지만, 컴퓨터에게 'long' 형식이 더 가독성이 높고, 데이터베이스 형식에 훨씬 더 가깝다.
데이터프레임에 ID 변수는 데이터베이스 필드(Field)와 유사하고, 관측변수는 데이터베이스 값(Value)와 유사하다.


## 시작하기 {#r-tidyr-start}

(아마도 이전 학습에서 `dplyr`팩키지는 설치했을 것이다) 
먼저 설치하지 않았다면, 팩키지를 설치한다:


```r
#install.packages("tidyr")
#install.packages("dplyr")
```

팩키지를 불러와서 적재한다.


```r
library("tidyr")
library("dplyr")
```

먼저, `gapminder` 데이터프레임 자료구조를 살펴보자:


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

## 도전과제 1 {#r-tidyr-challenge-one}

`gapminder`는 순수하게 'long' 형식인가, 'wide' 형식인가, 혹은 두가지 특징을 갖는 중간형식인가?

> **도전과제 1 에 대한 해답**
>
> 원 gapminder 데이터프레임은 두가지 특징을 갖는 중간 형식이다.
> 데이터프레임에 다수 관측변수 (`pop`,`lifeExp`,`gdpPercap`)가 있다는 점에서,
> 순수한 긴형식은 아니라고 볼 수 있다.
>

`gapminder` 데이터셋처럼, 관측된 데이터에 대한 다양한 자료형이 있다. 
대부분 순도 100% 'long' 혹은 순도 100% 'wide' 자료형식 사이 어딘가에 위치하게 된다.
`gapminder` 데이터셋에는 "ID" 변수가 3개(`continent`, `country`, `year`), "관측변수"가 3개(`pop`,`lifeExp`,`gdpPercap`) 있다.
저자는 일반적으로 대부분의 경우에 중간단계 형식 데이터를 선호한다.
칼럼 1곳에 모든 관측점이 3가지 서로 다른 단위를 갖지 않음에도 불구하고 그렇다.
데이터프레임을 좀더 늘리는 연산은 거의 없다(예를 들어, ID변수 4개, 관측변수 1개).


흔히 벡터기반인 다수 R 함수를 사용할 때, 흔히 다른 단위를 갖는 값에 수학적 연산작업을 수행하지는 않느다.
예를 들어, 순수 'long' 형식을 사용할 때, 
인구, 기대수명, GDP의 모든 값에 대한 평균은 의미가 없는데, 
이유는 상호 호환되지 않는 3가지 단위를 갖는 평균값을 계산하여 반환하기 때문이다.
해법은 먼저 집단으로 그룹지어서 데이터를 솜씨있게 다루거나 (`dplyr` 학습교재 참조), 
데이터프레임 구조를 변경시키는 것이다. 
**주의:** R에서 일부 도식화 함수는 'wide' 형식 데이터에 더 잘 작동한다.


## `gather()`로 `wide` &rarr; `long` 전환 {#r-tidyr-gather}

지금까지, 깔끔한 형식을 갖는 원본 `gapminder` 데이터셋으로 작업을 했다.
하지만, '실제' 데이터(즉, 자체 연구 데이터)는 절대로 잘 구성되어 있지 못하다.
`gapminder` 데이터셋에 대한 `wide` 형식 버젼을 갖고 시작해본다.

> [이곳에서](https://raw.githubusercontent.com/swcarpentry/r-novice-gapminder/gh-pages/_episodes_rmd/data/gapminder_wide.csv) 'wide' 형태를 갖는
> `gapminder` 데이터를 다운로드 받아서, 로컬 `data` 폴더에 저장시킨다.

데이터 파일을 불러와서 살펴보자.
주의: `continent`, `country` 칼럼이 요인형 자료형이 될 필요가 없다.
따라서 `read.csv()` 함수 인자로 `stringsAsFactors`을 거짓(FALSE)으로 설정한다.


```r
gap_wide <- read.csv("data/gapminder_wide.csv", stringsAsFactors = FALSE)
str(gap_wide)
```

```
## 'data.frame':	142 obs. of  38 variables:
##  $ continent     : chr  "Africa" "Africa" "Africa" "Africa" ...
##  $ country       : chr  "Algeria" "Angola" "Benin" "Botswana" ...
##  $ gdpPercap_1952: num  2449 3521 1063 851 543 ...
##  $ gdpPercap_1957: num  3014 3828 960 918 617 ...
##  $ gdpPercap_1962: num  2551 4269 949 984 723 ...
##  $ gdpPercap_1967: num  3247 5523 1036 1215 795 ...
##  $ gdpPercap_1972: num  4183 5473 1086 2264 855 ...
##  $ gdpPercap_1977: num  4910 3009 1029 3215 743 ...
##  $ gdpPercap_1982: num  5745 2757 1278 4551 807 ...
##  $ gdpPercap_1987: num  5681 2430 1226 6206 912 ...
##  $ gdpPercap_1992: num  5023 2628 1191 7954 932 ...
##  $ gdpPercap_1997: num  4797 2277 1233 8647 946 ...
##  $ gdpPercap_2002: num  5288 2773 1373 11004 1038 ...
##  $ gdpPercap_2007: num  6223 4797 1441 12570 1217 ...
##  $ lifeExp_1952  : num  43.1 30 38.2 47.6 32 ...
##  $ lifeExp_1957  : num  45.7 32 40.4 49.6 34.9 ...
##  $ lifeExp_1962  : num  48.3 34 42.6 51.5 37.8 ...
##  $ lifeExp_1967  : num  51.4 36 44.9 53.3 40.7 ...
##  $ lifeExp_1972  : num  54.5 37.9 47 56 43.6 ...
##  $ lifeExp_1977  : num  58 39.5 49.2 59.3 46.1 ...
##  $ lifeExp_1982  : num  61.4 39.9 50.9 61.5 48.1 ...
##  $ lifeExp_1987  : num  65.8 39.9 52.3 63.6 49.6 ...
##  $ lifeExp_1992  : num  67.7 40.6 53.9 62.7 50.3 ...
##  $ lifeExp_1997  : num  69.2 41 54.8 52.6 50.3 ...
##  $ lifeExp_2002  : num  71 41 54.4 46.6 50.6 ...
##  $ lifeExp_2007  : num  72.3 42.7 56.7 50.7 52.3 ...
##  $ pop_1952      : num  9279525 4232095 1738315 442308 4469979 ...
##  $ pop_1957      : num  10270856 4561361 1925173 474639 4713416 ...
##  $ pop_1962      : num  11000948 4826015 2151895 512764 4919632 ...
##  $ pop_1967      : num  12760499 5247469 2427334 553541 5127935 ...
##  $ pop_1972      : num  14760787 5894858 2761407 619351 5433886 ...
##  $ pop_1977      : num  17152804 6162675 3168267 781472 5889574 ...
##  $ pop_1982      : num  20033753 7016384 3641603 970347 6634596 ...
##  $ pop_1987      : num  23254956 7874230 4243788 1151184 7586551 ...
##  $ pop_1992      : num  26298373 8735988 4981671 1342614 8878303 ...
##  $ pop_1997      : num  29072015 9875024 6066080 1536536 10352843 ...
##  $ pop_2002      : int  31287142 10866106 7026113 1630347 12251209 7021078 15929988 4048013 8835739 614382 ...
##  $ pop_2007      : int  33333216 12420476 8078314 1639131 14326203 8390505 17696293 4369038 10238807 710960 ...
```

![](assets/images/r/14-tidyr-fig2.png){width=100%}

깔끔한 중간 데이터 형식을 얻는 첫단추는 먼저 'wide' 형식에서 'long' 형식으로 변환하는 것이다.
`tidyr` 팩키지 `gather()` 함수는 관측 변수를 모아서(gather) 단일 변수로 변환한다.

![](assets/images/r/14-tidyr-fig3.png){width=100%}


```r
gap_long <- gap_wide %>%
    gather(obstype_year, obs_values, starts_with('pop'),
           starts_with('lifeExp'), starts_with('gdpPercap'))
str(gap_long)
```

```
## 'data.frame':	5112 obs. of  4 variables:
##  $ continent   : chr  "Africa" "Africa" "Africa" "Africa" ...
##  $ country     : chr  "Algeria" "Angola" "Benin" "Botswana" ...
##  $ obstype_year: chr  "pop_1952" "pop_1952" "pop_1952" "pop_1952" ...
##  $ obs_values  : num  9279525 4232095 1738315 442308 4469979 ...
```

위에서 파이프 구문을 사용했는데, 이전 수업에서 `dplyr`로 작업한 것과 유사하다.
사실, `dplyr`과 `tidyr`은 상호 호환되어, 파이프 구문으로 `dplyr`과 `tidyr` 팩키지 함수를 섞어 사용한다.

`gather()` 함수 내부에, 먼저 신규 ID 변수(`obstype_year`)에 대한 명칭, 
병합된 관측변수(`obs_value`)에 대한 명칭, 그리고 나서 이전 관측변수에 대한 명칭을 신규 칼럼명으로 부여한다.
모든 관측변수를 타이핑했지만, `select()` 함수처럼(`dplyr` 수업 참조), 
`starts_with()` 함수에 인자로 넣어, 원하는 문자열로 시작되는 모든 변수를 선택할 수도 있다.
`gather()` 모을 필요없는 변수(예를 들어, ID 변수)를 식별하는데, 
`-` 기호를 사용하는 구문도 지원한다.

![](assets/images/r/14-tidyr-fig4.png){width=100%}


```r
gap_long <- gap_wide %>% gather(obstype_year,obs_values,-continent,-country)
str(gap_long)
```

```
## 'data.frame':	5112 obs. of  4 variables:
##  $ continent   : chr  "Africa" "Africa" "Africa" "Africa" ...
##  $ country     : chr  "Algeria" "Angola" "Benin" "Botswana" ...
##  $ obstype_year: chr  "gdpPercap_1952" "gdpPercap_1952" "gdpPercap_1952" "gdpPercap_1952" ...
##  $ obs_values  : num  2449 3521 1063 851 543 ...
```

이런 특수한 데이터프레임에는 별거 없어 보일 수도 있다.
하지만, ID 변수 하나, 규칙없는 변수명 관측변수 40개를 갖는 경우가 있을 수 있다.
이런 유연성은 시간을 상당히 절약해 준다!

이제 `obstype_year`은 정보가 두조각으로 나뉜다: 관측 유형(`pop`,`lifeExp`, `gdpPercap`)과 연도(`year`).
`separate()` 함수를 사용해서 문자열을 다수 변수로 쪼갠다.



```r
gap_long <- gap_long %>% separate(obstype_year,into=c('obs_type','year'),sep="_")
gap_long$year <- as.integer(gap_long$year)
```

## 도전 과제 2 {#r-tidyr-challenge-two}

`gap_long`을 사용해서, 각 대륙별로 평균 기대수명, 인구, 1인당 GDP를 계산한다.
**힌트:** `dplyr` 수업에서 학습한 `group_by()` 와 `summarize()` 함수를 사용한다.

> **도전과제 2 에 대한 해답**
>
>
>```r
>gap_long %>% group_by(continent,obs_type) %>%
>    summarize(means=mean(obs_values))
>```
>
>```
>## # A tibble: 15 x 3
>## # Groups:   continent [5]
>##   continent obs_type       means
>##   <chr>     <chr>          <dbl>
>## 1 Africa    gdpPercap     2194. 
>## 2 Africa    lifeExp         48.9
>## 3 Africa    pop        9916003. 
>## 4 Americas  gdpPercap     7136. 
>## 5 Americas  lifeExp         64.7
>## 6 Americas  pop       24504795. 
>## # ... with 9 more rows
>```

## `spread()`로 'long' 형식 변환 {#r-tidyr-wide}

이제 작업을 이중점검 하도록, 
`gather()` 역함수(적절히 작명된 `spread()`)를 사용해서 관측변수를 다시 되돌린다.
그리고 나면 `gap_long`을 원래 중간 형식 혹은 'wide' 형식으로 퍼뜨린다.
중간 형식에서부터 시작해보자.



```r
gap_normal <- gap_long %>% spread(obs_type,obs_values)
dim(gap_normal)
```

```
## [1] 1704    6
```

```r
dim(gapminder)
```

```
## [1] 1704    6
```

```r
names(gap_normal)
```

```
## [1] "continent" "country"   "year"      "gdpPercap" "lifeExp"   "pop"
```

```r
names(gapminder)
```

```
## [1] "country"   "year"      "pop"       "continent" "lifeExp"   "gdpPercap"
```
이제, 최초 데이터프레임 `gapminder`와 동일한 차원을 갖는 중간 데이터프레임 `gap_normal`이 있다.
하지만, 변수 순서가 다르다. 순서를 수정하기 전에, `all.equal()` 함수를 사용해서 동일한지 확인한다.


```r
gap_normal <- gap_normal[,names(gapminder)]
all.equal(gap_normal,gapminder)
```

```
## [1] "Component \"country\": 1704 string mismatches"          
## [2] "Component \"pop\": Mean relative difference: 1.63"      
## [3] "Component \"continent\": 1212 string mismatches"        
## [4] "Component \"lifeExp\": Mean relative difference: 0.204" 
## [5] "Component \"gdpPercap\": Mean relative difference: 1.16"
```

```r
head(gap_normal)
```

```
##   country year      pop continent lifeExp gdpPercap
## 1 Algeria 1952  9279525    Africa    43.1      2449
## 2 Algeria 1957 10270856    Africa    45.7      3014
## 3 Algeria 1962 11000948    Africa    48.3      2551
## 4 Algeria 1967 12760499    Africa    51.4      3247
## 5 Algeria 1972 14760787    Africa    54.5      4183
## 6 Algeria 1977 17152804    Africa    58.0      4910
```

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

거의 다 왔다. 최초 데이터프레임은 `country`, `continent`, `year` 순으로 정렬되었다.


```r
gap_normal <- gap_normal %>% arrange(country,continent,year)
all.equal(gap_normal,gapminder)
```

```
## [1] TRUE
```

훌륭하다! 'long' 형식에서 다시 중간 형식으로 돌아갔지만, 코드에 어떤 오류도 스며들지 않았다.

이제, 'long' 형식을 'wide' 형식으로 변환하자.
'wide' 형식에서, `country` 국가와 `contienet` 대륙을 ID 변수로 두고,
관츠점을 3가지 측정값(`pop`,`lifeExp`,`gdpPercap`)과 시간(`year`)으로 쭉 뿌렸다.
먼저, 모든 신규 변수(측정값 * 시간)에 대한 적절한 라벨을 생성할 필요가 있다.
또한, ID변수를 합쳐서 `gap_wide`를 정의하는 과정을 단순화할 필요가 있다.




```r
gap_temp <- gap_long %>% unite(var_ID,continent,country,sep="_")
str(gap_temp)
```

```
## 'data.frame':	5112 obs. of  4 variables:
##  $ var_ID    : chr  "Africa_Algeria" "Africa_Angola" "Africa_Benin" "Africa_Botswana" ...
##  $ obs_type  : chr  "gdpPercap" "gdpPercap" "gdpPercap" "gdpPercap" ...
##  $ year      : int  1952 1952 1952 1952 1952 1952 1952 1952 1952 1952 ...
##  $ obs_values: num  2449 3521 1063 851 543 ...
```

```r
gap_temp <- gap_long %>%
    unite(ID_var,continent,country,sep="_") %>%
    unite(var_names,obs_type,year,sep="_")
str(gap_temp)
```

```
## 'data.frame':	5112 obs. of  3 variables:
##  $ ID_var    : chr  "Africa_Algeria" "Africa_Angola" "Africa_Benin" "Africa_Botswana" ...
##  $ var_names : chr  "gdpPercap_1952" "gdpPercap_1952" "gdpPercap_1952" "gdpPercap_1952" ...
##  $ obs_values: num  2449 3521 1063 851 543 ...
```

`unite()`를 사용해서, `continent`,`country`를 묶는 ID변수가 하나 생겼고, 변수명을 정의했다.
이제 파이프를 통해서 `spread()` 뿌린 준비를 마쳤다.



```r
gap_wide_new <- gap_long %>%
    unite(ID_var,continent,country,sep="_") %>%
    unite(var_names,obs_type,year,sep="_") %>%
    spread(var_names,obs_values)
str(gap_wide_new)
```

```
## 'data.frame':	142 obs. of  37 variables:
##  $ ID_var        : chr  "Africa_Algeria" "Africa_Angola" "Africa_Benin" "Africa_Botswana" ...
##  $ gdpPercap_1952: num  2449 3521 1063 851 543 ...
##  $ gdpPercap_1957: num  3014 3828 960 918 617 ...
##  $ gdpPercap_1962: num  2551 4269 949 984 723 ...
##  $ gdpPercap_1967: num  3247 5523 1036 1215 795 ...
##  $ gdpPercap_1972: num  4183 5473 1086 2264 855 ...
##  $ gdpPercap_1977: num  4910 3009 1029 3215 743 ...
##  $ gdpPercap_1982: num  5745 2757 1278 4551 807 ...
##  $ gdpPercap_1987: num  5681 2430 1226 6206 912 ...
##  $ gdpPercap_1992: num  5023 2628 1191 7954 932 ...
##  $ gdpPercap_1997: num  4797 2277 1233 8647 946 ...
##  $ gdpPercap_2002: num  5288 2773 1373 11004 1038 ...
##  $ gdpPercap_2007: num  6223 4797 1441 12570 1217 ...
##  $ lifeExp_1952  : num  43.1 30 38.2 47.6 32 ...
##  $ lifeExp_1957  : num  45.7 32 40.4 49.6 34.9 ...
##  $ lifeExp_1962  : num  48.3 34 42.6 51.5 37.8 ...
##  $ lifeExp_1967  : num  51.4 36 44.9 53.3 40.7 ...
##  $ lifeExp_1972  : num  54.5 37.9 47 56 43.6 ...
##  $ lifeExp_1977  : num  58 39.5 49.2 59.3 46.1 ...
##  $ lifeExp_1982  : num  61.4 39.9 50.9 61.5 48.1 ...
##  $ lifeExp_1987  : num  65.8 39.9 52.3 63.6 49.6 ...
##  $ lifeExp_1992  : num  67.7 40.6 53.9 62.7 50.3 ...
##  $ lifeExp_1997  : num  69.2 41 54.8 52.6 50.3 ...
##  $ lifeExp_2002  : num  71 41 54.4 46.6 50.6 ...
##  $ lifeExp_2007  : num  72.3 42.7 56.7 50.7 52.3 ...
##  $ pop_1952      : num  9279525 4232095 1738315 442308 4469979 ...
##  $ pop_1957      : num  10270856 4561361 1925173 474639 4713416 ...
##  $ pop_1962      : num  11000948 4826015 2151895 512764 4919632 ...
##  $ pop_1967      : num  12760499 5247469 2427334 553541 5127935 ...
##  $ pop_1972      : num  14760787 5894858 2761407 619351 5433886 ...
##  $ pop_1977      : num  17152804 6162675 3168267 781472 5889574 ...
##  $ pop_1982      : num  20033753 7016384 3641603 970347 6634596 ...
##  $ pop_1987      : num  23254956 7874230 4243788 1151184 7586551 ...
##  $ pop_1992      : num  26298373 8735988 4981671 1342614 8878303 ...
##  $ pop_1997      : num  29072015 9875024 6066080 1536536 10352843 ...
##  $ pop_2002      : num  31287142 10866106 7026113 1630347 12251209 ...
##  $ pop_2007      : num  33333216 12420476 8078314 1639131 14326203 ...
```

## 도전과제 3 {#r-tidyr-challenge-three}

한 걸음 더 나아가, 국가, 연도, 측정값 3개를 쭉 뿌려 터무니 없는 `gap_ludicrously_wide` 형식 데이터를 생성한다.
**힌트:** 신규 데이터프레임은 단지 행이 5개만 있다.

> **도전과제 3 에 대한 해답**
>
>
>```r
>gap_ludicrously_wide <- gap_long %>%
>    unite(var_names,obs_type,year,country,sep="_") %>%
>    spread(var_names,obs_values)
>```

이제, 엄청 'wide' 형식 데이터프레임이 생겼다.
하지만, `ID_var` 변수는 더 유용할 수 있다. `separate()` 함수로 변수 2개로 구분하자.



```r
gap_wide_betterID <- separate(gap_wide_new,ID_var,c("continent","country"),sep="_")
gap_wide_betterID <- gap_long %>%
    unite(ID_var, continent,country,sep="_") %>%
    unite(var_names, obs_type,year,sep="_") %>%
    spread(var_names, obs_values) %>%
    separate(ID_var, c("continent","country"),sep="_")
str(gap_wide_betterID)
```

```
## 'data.frame':	142 obs. of  38 variables:
##  $ continent     : chr  "Africa" "Africa" "Africa" "Africa" ...
##  $ country       : chr  "Algeria" "Angola" "Benin" "Botswana" ...
##  $ gdpPercap_1952: num  2449 3521 1063 851 543 ...
##  $ gdpPercap_1957: num  3014 3828 960 918 617 ...
##  $ gdpPercap_1962: num  2551 4269 949 984 723 ...
##  $ gdpPercap_1967: num  3247 5523 1036 1215 795 ...
##  $ gdpPercap_1972: num  4183 5473 1086 2264 855 ...
##  $ gdpPercap_1977: num  4910 3009 1029 3215 743 ...
##  $ gdpPercap_1982: num  5745 2757 1278 4551 807 ...
##  $ gdpPercap_1987: num  5681 2430 1226 6206 912 ...
##  $ gdpPercap_1992: num  5023 2628 1191 7954 932 ...
##  $ gdpPercap_1997: num  4797 2277 1233 8647 946 ...
##  $ gdpPercap_2002: num  5288 2773 1373 11004 1038 ...
##  $ gdpPercap_2007: num  6223 4797 1441 12570 1217 ...
##  $ lifeExp_1952  : num  43.1 30 38.2 47.6 32 ...
##  $ lifeExp_1957  : num  45.7 32 40.4 49.6 34.9 ...
##  $ lifeExp_1962  : num  48.3 34 42.6 51.5 37.8 ...
##  $ lifeExp_1967  : num  51.4 36 44.9 53.3 40.7 ...
##  $ lifeExp_1972  : num  54.5 37.9 47 56 43.6 ...
##  $ lifeExp_1977  : num  58 39.5 49.2 59.3 46.1 ...
##  $ lifeExp_1982  : num  61.4 39.9 50.9 61.5 48.1 ...
##  $ lifeExp_1987  : num  65.8 39.9 52.3 63.6 49.6 ...
##  $ lifeExp_1992  : num  67.7 40.6 53.9 62.7 50.3 ...
##  $ lifeExp_1997  : num  69.2 41 54.8 52.6 50.3 ...
##  $ lifeExp_2002  : num  71 41 54.4 46.6 50.6 ...
##  $ lifeExp_2007  : num  72.3 42.7 56.7 50.7 52.3 ...
##  $ pop_1952      : num  9279525 4232095 1738315 442308 4469979 ...
##  $ pop_1957      : num  10270856 4561361 1925173 474639 4713416 ...
##  $ pop_1962      : num  11000948 4826015 2151895 512764 4919632 ...
##  $ pop_1967      : num  12760499 5247469 2427334 553541 5127935 ...
##  $ pop_1972      : num  14760787 5894858 2761407 619351 5433886 ...
##  $ pop_1977      : num  17152804 6162675 3168267 781472 5889574 ...
##  $ pop_1982      : num  20033753 7016384 3641603 970347 6634596 ...
##  $ pop_1987      : num  23254956 7874230 4243788 1151184 7586551 ...
##  $ pop_1992      : num  26298373 8735988 4981671 1342614 8878303 ...
##  $ pop_1997      : num  29072015 9875024 6066080 1536536 10352843 ...
##  $ pop_2002      : num  31287142 10866106 7026113 1630347 12251209 ...
##  $ pop_2007      : num  33333216 12420476 8078314 1639131 14326203 ...
```

```r
all.equal(gap_wide, gap_wide_betterID)
```

```
## [1] TRUE
```

다시 되돌아 왔다!


## 추가 학습 {#r-tidyr-points}

* [R for Data Science](http://r4ds.had.co.nz/index.html)
* [Data Wrangling Cheat sheet](https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf)
* [Introduction to tidyr](https://cran.r-project.org/web/packages/tidyr/vignettes/tidy-data.html)
* [Data wrangling with R and RStudio](https://www.rstudio.com/resources/webinars/data-wrangling-with-r-and-rstudio/)
