---
output: html_document
editor_options: 
  chunk_output_type: console
---



# RStudio 프로젝트 관리 {#r-project}

## 들어가며 {#r-project-intro}

과학적 과정은 본질적으로 증분이다.
프로젝트 대부분은 아무렇게 적은 노트필기, 일부 코드, 그리고 나서, 원고작성, 그리고 나면
종국에 모든 것이 함께 섞여진다.

<blockquote class="twitter-tweet"><p>Managing your projects in a reproducible fashion does not just make your science reproducible, it makes your life easier.</p>— Vince Buffalo <a href="https://twitter.com/vsbuffalo/status/323638476153167872">April 15, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

대부분은 다음과 같이 프로젝트를 구조화하는 경향이 있다:

![흔한 프로젝트 디렉토리 구조](assets/images/r/bad_layout.png){width=100%}

*항상* 이런 방식을 회피해야 되는 이유는 많다:

1. 어느 데이터 버젼이 원본이고, 어느 데이터 버젼이 변경된 것인지 분간하기 정말 힘들다;
2. 다양한 확장자를 갖는 파일과 뒤섞일 때, 정말 엉망이 된다;
3. 아마도 실제 파일을 찾고, 해당 그래프를 생성하는데 사용된 정확한 프로그램 코드와 
    맞는 그림을 연결시키는데 시간이 엄청 많이 소요될 것이다.

프로젝트를 잘 배치하게 되면 궁극적으로 여러분의 삶을 편안하게 만들어 줄 것이다:

* 데이터 정합성을 보장할 것이다;
* 작성한 코드를 다른 사람(연구실 동료, 공동연구자, 지도교수)과 더 단순하게 공유할 수 있게 만든다;
* 논문 제출할 때 코드를 쉽게 업로드할 수 있게 한다;
* 휴가 뒤에, 프로젝트 백업을 더 손쉽게 한다.


## 가능한 해결책 {#r-project-solution}

다행스럽게도, 작업을 효과적으로 관리할 수 있게 도움이 되는 도구와 팩키지가 있다.

RStudio의 가장 강력하고 유용한 측면 중 하나가 프로젝트 관리 기능이다.
프로젝트 관리 기능을 사용해서, 모든 것이 갖춘 재현가능한 프로젝트를 생성한다.

## 도전과제 {#r-project-challenge-one}

모든 것을 갖춘 프로젝트 생성해보자. 
RStudio에서 새로운 프로젝트를 생성한다:

1. "File" 메뉴를 클릭하고 나서, "New Project" 선택한다.
2. "New Directory"를 클릭한다.
3. "Empty Project"를 클릭한다.
4. 프로젝트를 저장할 디렉토리 명칭을 타이핑한다. 예를 들어, "my_project".
5. "Create a git repository"에 대한 체크박스가 선택되었는지 확실히 한다.
6. "Create Project" 버튼을 클릭한다.


이제 프로젝트 디렉토리에서 R을 시작하거나, RStudio로 해당 프로젝트를 열게 되면,
프로젝트에 모든 작업은 해당 디렉토리에 완전히 담겨지게 된다.

## 프로젝트 구성 모범 사례  {#r-project-best-practice}

프로젝트를 구성하는 "가장 최선의" 방식이 없지만, 프로젝트 관리를 더 수월하게 하는데
준수해야 되는 일반적인 원칙이 몇가지 있다:

### 데이터는 읽기 전용 {#r-project-data-read}

아마도 이것이 프로젝트 설정에 대한 가장 중요한 목적이다.
데이터는 일반적으로 수집하는데 시간이 많이 걸리고 비용이 많이 든다.
(엑셀처럼) 인터랙티브하게 데이터를 작업하게 되면, 필연적으로 데이터에 변형이 
일어나고 데이터 출처와, 수집이 이루어진 뒤에 어떻게 
변형되었는지 확인을 할 수 없게 된다.
따라서, 데이터를 **"읽기-전용(Read-Only)"**으로 다룬다.

### 데이터 정제 {#r-project-data-cleansing}

많은 경우에, 데이터가 "지저분하다":
상당한 전처리 과정을 거쳐야 R 형식(혹은 다른 프로그래밍 언어)으로 유용하게 사용될 수 있다.
이런 작업이 "데이터 정제작업"(Data Munging, Data Wrangling)이라고 불린다.
별도 디렉토리에 데이터 정제 스크립트를 보관하고,
"정제된" 데이터셋을 보관하는 두번째 "읽기-전용" 데이터 디렉토리를 생성하는 것도 유용하다.


### 자동생성 산출물은 일회용품 {#r-project-artifacts}

작성한 스크립트로 자동생성된 어떤 것이든 일회용품처럼 처리해만 된다:
작성한 스크립트가 모두 다시 자동생성할 수 있어야만 된다.

자동출력된 산출물을 관리하는 다른 방식은 많다. 
각기 다른 분석마다 다른 하위디렉토리에 출력결과를 저장하는 것이 유용하다.
나중을 위해서 이런 접근법이 더 수월한데, 대부분의 분석이 탐색적이고, 최종 프로젝트에 
채택되지도 않기 때문이고, 일부 분석 결과는 프로젝트 중간에 공유되기도 한다.

::: {#r-good-enough .rmdcaution}

**꿀팁: 과학적 컴퓨팅 위한 적정 관행**

[Good Enough Practices for Scientific Computing](https://github.com/swcarpentry/good-enough-practices-in-scientific-computing/blob/gh-pages/good-enough-practices-for-scientific-computing.pdf)에서 프로젝트 구조화에 대한 다음과 같은 추천사항을 제시하고 있다:

1. 프로젝트명을 따서 자체 디렉토리를 갖도록 각 프로젝트를 배치한다.
2. `doc` 디렉토리에 프로젝트와 연관된 텍스트 문서를 배치한다.
3. `data` 디렉토리에 원본데이터와 메타데이터를 배치하고 `results` 디렉토리에 분석과정에서 생성되는 파일을 배치시킨다.
4. `src` 디렉토리에 프로젝트 스크립트와 프로그램 소스 코드를 배치하고, `bin` 디렉토리에 로컬 컴퓨터에서 컴파일 되거나 외부에서 가져온 프로그램을 배치한다.
5. 모든 파일이름을 콘텐츠 혹은 함수를 적절히 반영하도록 이름 짓는다.

:::

### 재사용 함수 정의와 응용활용을 구별 {#r-project-reuse}

R로 작업하는 가장 효과적인 방법이 인터랙티브 세션에서 여러가지 작업을 하다가,
제대로 동작하고 원하는 기능이 구현되면 .R 스크립트 파일로 명령어를 복사해서 넣는 것이다.
`history` 명령어를 사용해서 지금까지 입력한 모든 명령어를 저장할 수도 있다.
하지만, 명령어 90%가 시행착오라 그다지 유용하지 않을 수 있다.

프로젝트가 새롭고 참신할 때, 스크립트 파일에 대체로 직접 실행되는 코드 라인이 많이 포함되어 있다.
코드 성숙도가 높아짐에 따라, 재사용가능한 코드 덩어리를 함수로 뽑아낸다.
이런 함수를 별도 디렉토리에 몰아 넣는 것도 좋은 아이디어다;
여러 분석에 걸쳐 폭넓게 재사용되는 유용한 디렉토리와 분석 스크립트를 저장하는 디렉토리.

::: {#r-avoid-rework .rmdcaution}

**꿀팁: 중복 회피하기**

다수 프로젝트에서 데이터와 분석 스크립트를 사용하는 경우가 있다.
일반적으로, 중복을 피해서, 공간도 절약하고, 여러 곳에 코드를 갱신하는 수고도 회피하고자 한다.
 
이런 경우, "기호 연결(Symbolic Link)"가 유용한다. 
본질적으로 파이시스템 어딘가 있는 파일에 대한 단축키다.
리눅스나 맥 OS X에서는 `ln -s` 명령어를 사용하고,
윈도우에서는 단축키를 생성하거나, `mklink` 명령어를 윈도우 터미널에서 사용한다.
:::


### 데이터 디렉토리에 데이터 저장 {#r-project-save-data}

이제 멋진 디렉토리 구조를 갖추어서, `data/` 디렉토리에 데이터 파일을 위치/저장한다.

## 도전 과제 1 {#r-project-challenge-good}
 
gapminder 데이터를 [웹사이트](https://raw.githubusercontent.com/resbaz/r-novice-gapminder-files/master/data/gapminder-FiveYearData.csv)
에서 다운로드 한다.

1. 파일을 다운로드한다 (CTRL + S, 마우스 우클릭 -> "Save as", 혹은 File -> "Save page as")
2. `gapminder-FiveYearData.csv` 파일명으로 저장된 것인지 확인한다.
3. 프로젝트 내부 `data/` 디렉토리에 파일을 저장한다.

나중에 데이터를 불러 적재하고 검사작업을 진행한다.

### 버전 제어 {#r-project-git}

프로젝트와 버전 제어를 사용하는 것이 중요하다.

## 도전 과제 1 {#r-project-challenge-two}
 
데이터를 R에 올리기 전에, 프롬프트 명령라인에서 데이터셋에 대한 전반적인 아이디어를 획득하는 것이 좋다. 
R에 데이터를 올리는 방법을 결정할 때 데이터셋에 대해 더 잘 이해하는 것이 수월하게 된다.
다음 질문에 답을 하는데 명령라인 쉘을 사용하라.
1. 파일 크기는 얼마나 되는가?
2. 데이터 행수는 얼마나 되는가?
3. 데이터 파일에는 어떤 유형의 값이 저장되어 있는가?

> **도전과게 2에 대한 해답**
>
> 쉘에 다음 명령어를 실행한다.:
>
> 
> ```sh
> ls -lh data/gapminder_data.csv
> ```
> 
> ```
> ## -rw-r--r-- 1 statkclee 없음 80K May 12 23:26 data/gapminder_data.csv
> ```
>
> 파일 크기는 80K.
>
> 
> ```sh
> wc -l data/gapminder_data.csv
> ```
> 
> ```
> ## 1705 data/gapminder_data.csv
> ```
>
> 1705 줄이다. 데이터는 다음과 같이 생겼다:
>
> 
> ```sh
> head data/gapminder_data.csv
> ```
> 
> ```
> ## country,year,pop,continent,lifeExp,gdpPercap
> ## Afghanistan,1952,8425333,Asia,28.801,779.4453145
> ## Afghanistan,1957,9240934,Asia,30.332,820.8530296
> ## Afghanistan,1962,10267083,Asia,31.997,853.10071
> ## Afghanistan,1967,11537966,Asia,34.02,836.1971382
> ## Afghanistan,1972,13079460,Asia,36.088,739.9811058
> ## Afghanistan,1977,14880372,Asia,38.438,786.11336
> ## Afghanistan,1982,12881816,Asia,39.854,978.0114388
> ## Afghanistan,1987,13867957,Asia,40.822,852.3959448
> ## Afghanistan,1992,16317921,Asia,41.674,649.3413952
> ```

::: {#r-rstudio-shell .rmdcaution}

**꿀팁: R Studio에서 명령라인**

`**Tools -> Shell...**` 메뉴를 통해서 RStudio에서 쉘을 띄울 수 있다.

:::





