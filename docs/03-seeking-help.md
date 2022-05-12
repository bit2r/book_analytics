---
output: html_document
editor_options: 
  chunk_output_type: console
---



# 도움 청하기 {#r-help}

## 도움말 파일 읽기 {#r-help-read}

R과 모든 팩키지는 함수에 대한 도움말 파일을 제공한다.
네임스페이스(인터랙티브 R 세션)에 적재된 팩키지에 있는 특정 함수에 대한 도움말은 다음과 같이 찾는다:


```r
?function_name
help(function_name)
```

RStudio에 도움말 페이지에 도움말이 표시된다. (혹은 R 자체로 일반 텍스트로 표시된다)

각 도움말 페이지는 절(section)로 구분된다:

 - 기술(Description): 함수가 어떤 작업을 수행하는가에 대한 충분한 기술
 - 사용법(Usage): 함수 인자와 기본디폴트 설정값
 - 인자(Arguments): 각 인자가 예상하는 데이터 설명 
 - 상세 설명(Details): 알고 있어야 되는 중요한 구체적인 설명
 - 값(Value): 함수가 반환하는 데이터
 - 함께 보기(See Also): 유용할 수 있는 연관된 함수.
 - 예제(Examples): 함수 사용법에 대한 예제들.

함수마다 상이한 절을 갖추고 있다.
하지만, 상기 항목이 알고 있어야 하는 핵심 내용이다.

::: {#r-help-tips .rmdcaution}

**꿀팁: 도움말 파일 불러 읽어오기**

R에 대해 가장 기죽게 되는 한 측면이 엄청난 함수 갯수다.
모든 함수에 대한 올바른 사용법을 기억하지 못하면,
엄두가 나지 않을 것이다.
운좋게도, 도움말 파일로 인해 기억할 필요가 없다!

:::


## 특수 연산자 {#r-help-special}

특수 연산자에 대한 도움말을 찾으려면, 인용부호를 사용한다:


```r
?"<-"
```

## 팩키지 도움말 얻기 {#r-help-pkg}

많은 팩키지에 "소품문(vignettes)"이 따라온다: 활용법과 풍부한 예제를 담은 문서.
어떤 인자도 없이, `vignette()` 명령어를 입력하면 설치된 모든 팩키지에 대한 
모든 소품문 목록이 출력된다;
`vignette(package="package-name")` 명령어는 `package-name` 팩키지명에 대한
이용가능한 모든 소품문 목록을 출력하고, `vignette("vignette-name")` 
명령어는 특정된 소품문을 연다.

팩키지에 어떤 소품문도 포함되지 않는다면, 일반적으로 
`help("package-name")` 명령어를 타이핑해서 도움말을 얻는다.

## 함수가 정확하게 기억나지 않을 때 {#r-help-function}

함수가 어느 팩키지에 있는지 확신을 못하거나, 구체적인 철자법을 모르는 경우,
퍼지 검색(fuzzy search)을 실행한다:


```r
??function_name
```

## 어디서 시작해야 될지 아무 생각이 없을 때 {#r-help-no-idea}

어떤 함수 혹은 팩키지가 필요한지 모르는 경우,
[CRAN Task Views](http://cran.at.r-project.org/web/views) 사이트가 
좋은 시작점이 된다. 유지관리되는 팩키지 목록이 필드로 묶여 잘 정리되어 있다.

## 코드가 동작않을 때: 동료에게 도움 구함 {#r-help-not-working}

함수 사용에 어려움이 있는 경우, 10 에 9 경우에 찾는 정답이
이미 [Stack Overflow](http://stackoverflow.com/)에 답글이 달려 있다.
검색할 때 `[r]` 태그를 사용한다:

원하는 답을 찾지 못한 경우, 동료에게 질문을 만드는데 몇가지 유용한 함수가 있다:



```r
?dput
```

`dput()` 함수는 작업하고 있는 데이터를 텍스트 파일 형식으로 덤프해서 저장한다.
그래서 다른 사람 R 세션으로 복사해서 붙여넣기 좋게 돕는다.



```r
sessionInfo()
```

```
## R version 4.2.0 (2022-04-22 ucrt)
## Platform: x86_64-w64-mingw32/x64 (64-bit)
## Running under: Windows 10 x64 (build 19043)
## 
## Matrix products: default
## 
## locale:
## [1] LC_COLLATE=Korean_Korea.utf8  LC_CTYPE=Korean_Korea.utf8   
## [3] LC_MONETARY=Korean_Korea.utf8 LC_NUMERIC=C                 
## [5] LC_TIME=Korean_Korea.utf8    
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
##  [1] forcats_0.5.1   stringr_1.4.0   dplyr_1.0.8     purrr_0.3.4    
##  [5] readr_2.1.2     tidyr_1.2.0     tibble_3.1.6    ggplot2_3.3.5  
##  [9] tidyverse_1.3.1 DBI_1.1.2      
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_1.0.8.3     lubridate_1.8.0  assertthat_0.2.1 digest_0.6.29   
##  [5] utf8_1.2.2       R6_2.5.1         cellranger_1.1.0 backports_1.4.1 
##  [9] reprex_2.0.1     RSQLite_2.2.12   evaluate_0.15    httr_1.4.2      
## [13] pillar_1.7.0     rlang_1.0.2      readxl_1.4.0     rstudioapi_0.13 
## [17] blob_1.2.3       jquerylib_0.1.4  rmarkdown_2.13   bit_4.0.4       
## [21] munsell_0.5.0    broom_0.8.0      compiler_4.2.0   modelr_0.1.8    
## [25] xfun_0.30        pkgconfig_2.0.3  htmltools_0.5.2  downlit_0.4.0   
## [29] tidyselect_1.1.2 bookdown_0.26    fansi_1.0.3      crayon_1.5.1    
## [33] tzdb_0.3.0       dbplyr_2.1.1     withr_2.5.0      grid_4.2.0      
## [37] jsonlite_1.8.0   gtable_0.3.0     lifecycle_1.0.1  magrittr_2.0.3  
## [41] scales_1.2.0     cli_3.2.0        stringi_1.7.6    cachem_1.0.6    
## [45] fs_1.5.2         xml2_1.3.3       bslib_0.3.1      ellipsis_0.3.2  
## [49] generics_0.1.2   vctrs_0.4.1      tools_4.2.0      bit64_4.0.5     
## [53] glue_1.6.2       hms_1.1.1        fastmap_1.1.0    yaml_2.3.5      
## [57] colorspace_2.0-3 rvest_1.0.2      memoise_2.0.1    knitr_1.38      
## [61] haven_2.5.0      sass_0.4.1
```

`sessionInfo()`는 R 현재 버젼 정보과 함께 적재된 팩키지 정보를 출력한다.
이 정보가 다른 사람이 여러분 문제를 재현하고 디버그하는데 유용할 수 있다.

## 도전과제 1  {#r-help-challenge-one}

`c` 연결함수에 대한 도움말을 살펴본다.
다음 명령어를 실행하면, 어떤 종류 벡터가 생성될 것으로 예상되는가:


```r
c(1, 2, 3)
c('d', 'e', 'f')
c(1, 2, 'f')`
```

> **도전과제 1에 대한 해답**
>
> `c()` 함수는 벡터를 생성하는데 벡터내 모든 원소는 동일한 자료형태여야 한다.
> 첫번째의 경우 모든 원소는 숫자형이다. 두번째의 경우 모두 문자형이다.
> 세번째의 경우 문자형이다: 숫자형은 문자로 강제변환(coerced) 된다.

## 도전과제 2  {#r-help-challenge-two}

`paste` 함수에 대한 도움말을 살펴본다.
나중에 이 함수를 사용할 것이다.
`sep` 와 `collapse` 인자 사이에 차이는 무엇인가?

> **도전과제 2에 대한 해답**
>
> `paste()` 함수에 대한 도움말은 다음 명령어를 사용한다:
>
> 
> ```r
> help("paste")
> ?paste
> ```
>
> `sep`, `collapse` 함수 차이는 다소 난해하다.
> `paste` 함수는 임의 숫자 인자를 받는데 각가은 임의 길이를 갖는 벡터가 될 수 있다.
> `sep` 인자는 결합되는 요소들 사이에 문자를 지정한다; 기본디폴트로 공백이 된다.
> 반환되는 결과는 벡터로 된다. 반대로 `collapse`는 원소를 결합한 후에 해당 구분자를 
> 이용하여 축약되어 하나의 문자열이 된다. 예를 들어,
> 
> 
> ```r
> paste(c("a","b"), "c")
> ```
> 
> ```
> ## [1] "a c" "b c"
> ```
> 
> ```r
> paste(c("a","b"), "c", sep = ",")
> ```
> 
> ```
> ## [1] "a,c" "b,c"
> ```
> 
> ```r
> paste(c("a","b"), "c", collapse = "|")
> ```
> 
> ```
> ## [1] "a c|b c"
> ```
> 
> ```r
> paste(c("a","b"), "c", sep = ",", collapse = "|")
> ```
> 
> ```
> ## [1] "a,c|b,c"
> ```
>
> (추가 정보가 필요한 경우,
> `paste` 도움말 페이지 하단에 예제를 참조한다.
> 혹은 `example('paste')` 명령어를 실행한다.

## 도전과제 3 {#r-help-challenge-three}

칼럼이 탭("\t")와 소수점(".")으로 구분되는 csv 파일을 불러올 수 있는 함수(연관된 모수)를 찾아내는데 
도움말을 사용해보자.
소수점 구분자에 대한 확인이 중요한데 전세계 동료와 공동작업을 한다면 더욱 그렇다.
왜냐하면 다른 나라는 소수점 표기에 다른 관례를 사용하기 때문이다(예를 들어, 콤마 vs 점)
힌트: `??csv` 명령어를 사용해서 csv 관련 함수를 찾아낸다.

> **도전과제 3에 대한 해답**
>
> 소수점 구분자를 갖는 탭 구분 파일을 읽어 오는 표준 R 함수는 `read.delim()`이다.
> `read.table(file, sep="\t")` 명령어로 작업을 수행할 수 있다. 
> `read.table()` 함수에 소수점이 기본설정된 구분자이며, 
> 데이터파일에 hash (#) 문자를 갖가 포함되어 있다면 `comment.char` 인자도 변경해야 한다.

## 도움 되는 웹사이트 {#r-help-website}

* [Quick R](http://www.statmethods.net/)
* [RStudio cheat sheets](http://www.rstudio.com/resources/cheatsheets/)
* [Cookbook for R](http://www.cookbook-r.com/)
