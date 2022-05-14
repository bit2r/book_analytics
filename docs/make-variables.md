

# 자동 변수 {#make-makefiles}

앞선 수업 말미 연습문제를 푼 후, Makefile 은 다음과 같아 보인다:

```
# Count words.
.PHONY : dats
dats : isles.dat abyss.dat last.dat

isles.dat : books/isles.txt
        python wordcount.py books/isles.txt isles.dat

abyss.dat : books/abyss.txt
        python wordcount.py books/abyss.txt abyss.dat

last.dat : books/last.txt
        python wordcount.py books/last.txt last.dat

# Generate archive file.
analysis.tar.gz : isles.dat abyss.dat last.dat
        tar -czf analysis.tar.gz isles.dat abyss.dat last.dat

.PHONY : clean
clean :
        rm -f *.dat
        rm -f analysis.tar.gz
```

Makefile에 중복이 엄청 많다.
예를 들어, 텍스트 파일과 데이터 파일 명칭이 Makefile 전역에 걸쳐 여러 곳에서 반복되고 있다.
Makefile은 코드의 한 형태로, 어떤 코드에서나 그렇듯이 반복되는 코드는 문제가 될 소지가 있다.
예를 들어, Makefile의 일부에서 데이터 파일 명칭을 바꾸고 나서 다른 곳에 명칭을 바꾸는 것을 잊곤 한다.

::: {#make-dry .rmdcaution}

**D.R.Y.(Don't Repeat Yourself)**

대다수 프로그래밍 언어에서 프로그래머가 긴 연산과정 루틴을 간결하고 표현력있고 
아름다운 코드로 기술할 수 있는 기능을 지원한다.
R, 파이썬, 자바 언어에 사용자 정의 변수와 함수 기능이 유용한데 이유는
구체적인 모든 사항을 반복해서 작성할 필요가 없기 때문이다.
단지 한번만 작성하는 이러한 좋은 프로그래밍 습관이 **D.R.Y.(Don't Repeat Yourself)**
원칙으로 알려져 있다. 우리나라 말로 복붙, 삽질 하지말자 정도가 체감상 맞을 듯 싶다.

:::

Makefile 에서 반복되는 코드를 제거해 나가자.
`results.txt` 규칙에서, 데이터 파일과 파일 저장소 아카이브 명칭이 중복된다:

```
results.txt : isles.dat abyss.dat last.dat
	python testzipf.py abyss.dat isles.dat last.dat > results.txt
```

먼저 문서저장소 아카이브 명칭을 살펴보면, 
동작에 나온 문서저장소 명칭을 `$@`으로 교체할 수 있다:

```
results.txt : isles.dat abyss.dat last.dat
  python testzipf.py abyss.dat isles.dat last.dat > $@
```

`$@`은 Make **자동 변수(automatic variable)**로,
'현재 규칙에 대한 대상'을 의미한다.
Make가 실행되면, Make가 해당 변수를 대상 명칭으로 교체한다.

동작에 나온 의존성을 `$^`으로 교체할 수 있다:

```
results.txt : isles.dat abyss.dat last.dat
	python testzipf.py $^ > $@
```

`$^`은 또다른 자동변수로, '현재 규칙에 대한 모든 의존성'을 의미한다.
다시 한번, Make가 실행될 때, Make가 해당 변수를 의존성으로 교체한다.

텍스트 파일을 갱신하고, 위에서 작성한 규칙을 재실행한다:

```
$ touch books/*.txt
$ make results.txt
```

다음에 산출 결과가 나와 있다:

```
python countwords.py books/isles.txt isles.dat
python countwords.py books/abyss.txt abyss.dat
python countwords.py books/last.txt last.dat
python testzipf.py isles.dat abyss.dat last.dat > results.txt
```

## 의존성 갱신하기 {#make-dependency-challenge}

지금 다음을 실행하면 어떤 일이 발생할까:

```
$ touch *.dat
$ make analysis.tar.gz
```

1. 아무 일도 없다.
2. 모든 파일이 다시 생성된다.
3. 단지 `.dat` 파일만 다시 생성된다.
4. 단지 `results.txt`만 다시 생성된다.

> **도전과제 해법**
> `4.` 단지 `results.txt`만 다시 생성된다.
> 
> `*.dat`에 대한 규칙은 실행되지 않는데 이유는 해당되는 `.txt` 파일 변경이
> 일어나지 않아서 그렇다.
>
> 다음을 실행하게 되면
>
> ```
> $ touch books/*.txt
> $ make results.txt
> ```
>
> `.dat` 파일과 `results.txt` 파일이 다시 생성된 것을 확인할 수 있다.


위에서 살펴봤듯이, `$^`은 '현재 규칙에 대한 모든 의존성'을 의미한다.
`results.txt` 파일에 대해서는 잘 동작하는데, 
이유는 해당 동작이 모든 의존성을 `testzipf.py`에 입력처럼 동일하게 처리하기 때문이다.

하지만, 일부 규칙에 대해, 첫째 의존성을 다르게 처리하고 싶을 수 있다.
예를 들어, `.dat` 파일에 대한 규칙은 첫째 의존성(만을) 사용해서 `wordcount.py` 에 
입력 파일로 적용코져 한다.
만약 추가적인 의존성을 추가하면(곧 그렇듯이), `countwords.py`에 입력 파일로 전달되면 안된다. 
왜냐하면, 호출될 때 입력 파일만 호명되길 기대하기 때문이다.

Make는 이런 목적을 위한 자동변수가 있는데 `$<`으로, 
'현재 규칙에 대한 첫째 의존성'을 의미한다.

## 자동변수 규칙 작성 {#make-automatic-challenge}

자동 변수를 사용하도록 `.dat` 규칙을 다시 작성하시오.

자동 변수  `$@`('현재 규칙에 대한 대상')와 `$<` ('현재 규칙에 대한 첫째 의존성')을 사용하도록 `.dat` 규칙을 다시 작성하시오.

```
# Generate summary table.
results.txt : *.dat
	python testzipf.py $^ > $@

# Count words.
.PHONY : dats
dats : isles.dat abyss.dat last.dat

isles.dat : books/isles.txt
	python countwords.py books/isles.txt isles.dat

abyss.dat : books/abyss.txt
	python countwords.py books/abyss.txt abyss.dat

last.dat : books/last.txt
	python countwords.py books/last.txt last.dat

.PHONY : clean
clean :
	rm -f *.dat
	rm -f results.txt
```

> **자동변수 적용 해답**
> 
> ```
> # Generate summary table.
> results.txt : isles.dat abyss.dat last.dat
> 	python testzipf.py $^ > $@
> 
> # Count words.
> .PHONY : dats
> dats : isles.dat abyss.dat last.dat
> 
> isles.dat : books/isles.txt
> 	python countwords.py $< $@
> 
> abyss.dat : books/abyss.txt
> 	python countwords.py $< $@
> 
> last.dat : books/last.txt
> 	python countwords.py $< $@
> 
> .PHONY : clean
> clean :
> 	rm -f *.dat
> 	rm -f results.txt
> ```


## 자동변수 요약 {#make-autovariable-points}

* Make 자동변수를 사용해서 Makefile에 중복을 제거한다.
* `$@`을 사용해서 현재 규칙에 있는 대상을 참조한다.
* `$^`을 사용해서 현재 규칙에 있는 의존성을 참조한다.
* `$<`을 사용해서 현재 규칙에 있는 첫째 의존성을 참조한다.


