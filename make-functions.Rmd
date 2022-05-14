

# 함수 {#make-function}


현재 시점엣, Makefile은 다음과 같다:

```
include config.mk

# Generate summary table.
results.txt : $(ZIPF_SRC) isles.dat abyss.dat last.dat
	$(ZIPF_EXE) *.dat > $@

# Count words.
.PHONY : dats
dats : isles.dat abyss.dat last.dat

%.dat : books/%.txt $(COUNT_SRC)
	$(COUNT_EXE) $< $*.dat

.PHONY : clean
clean :
	rm -f *.dat
	rm -f results.txt
```

Make에는 많은 **함수(functions)**가 지원되어 더 복잡한 규칙을 작성할 수 있다. 한 사례가 `wildcard`다. `wildcard`는 특정 패턴과 매칭되는 파일 목록을 얻어와서,
변수에 저장할 수 있다. 예를 들어, 모든 텍스트 파일(`.txt`로 끝나는 파일) 목록을 불러와서
Makefile 시작부분에 변수에 불러온 값을 저장한다:

```
TXT_FILES=$(wildcard books/*.txt)
```

변수의 값을 보여주도록 `.PHONY` 대상과 규칙으로 추가한다:

```
.PHONY : variables
variables:
	@echo TXT_FILES: $(TXT_FILES)
```

::: {#make-function-echo .rmdcaution}

**@echo**

Make는 동작을 실행할 때 동작을 화면에 출력한다.
동작 시작부에 `@`을 사용하면 Make로 하여금 동작을 출력하지 않게 한다.
그래서, `echo` 대신에 `@echo`을 사용함으로써, 
`echo` 실행 결과(변수값을 출력)를 볼 수 있지만, `echo` 명령어 자체는 볼 수 없게 된다.

:::

Make를 실행하면:

```
$ make variables
```

다음 결과를 얻게 된다:

```
TXT_FILES: books/abyss.txt books/isles.txt books/last.txt books/sierra.txt
```

이제 `sierra.txt`도 포함된 것에 주목한다.

함수를 도입한 후,  `analysis.tar.gz`에 명기된 대상을 빌드하는데 관여된 의존성을 도식화했는데, 
Makefile에서 구현된 사항이 다음 그림에 나와 있다:

`patsubst` ('pattern substitution', 패턴 치환)은 패턴, 대체 문자열, 명칭 목록을 순서대로 받는다;
목록에 나와 있는 패턴과 매칭되는 명칭은 대체 문자열로 치환된다. 다시, 결과는 변수에 저장한다.
예를 들어, 텍스트 파일 목록을 데이터 파일 목록(`.dat`로 끝나는 파일)으로 다시 작성하고 해당 결과를 변수에 저장한다:

```
DAT_FILES=$(patsubst books/%.txt, %.dat, $(TXT_FILES))
```

`variables`을 연장해서 `DAT_FILES` 값을 보여준다:

```
.PHONY : variables
variables:
	@echo TXT_FILES: $(TXT_FILES)
	@echo DAT_FILES: $(DAT_FILES)
```

Make를 실행하면,

```
$ make variables
```

다음 결과를 얻게 된다:

```
TXT_FILES: books/abyss.txt books/isles.txt books/last.txt books/sierra.txt
DAT_FILES: abyss.dat isles.dat last.dat sierra.dat
```

이제, `sierra.txt` 파일도 처리된다.

이것을 갖고, `clean` 과 `dats` 파일을 다시 작성한다:

```
.PHONY : clean
clean :
        rm -f $(DAT_FILES)
        rm -f analysis.tar.gz

.PHONY : dats
dats : $(DAT_FILES)
```

검사해 봅시다:

```
$ make clean
$ make dats
```

다음 결과를 얻게된다:

```
python countwords.py books/abyss.txt abyss.dat
python countwords.py books/isles.txt isles.dat
python countwords.py books/last.txt last.dat
python countwords.py books/sierra.txt sierra.dat
```

`results.txt` 도 다시 작성할 수 있다:

```
results.txt : $(ZIPF_SRC) $(DAT_FILES)
	$(ZIPF_EXE) $(DAT_FILES) > $@
```

Make를 다시 실행하면:

```
$ make clean
$ make results.txt
```

다음 결과를 얻게 된다:

```
python countwords.py books/abyss.txt abyss.dat
python countwords.py books/isles.txt isles.dat
python countwords.py books/last.txt last.dat
python countwords.py books/sierra.txt sierra.dat
python testzipf.py  last.dat  isles.dat  abyss.dat  sierra.dat > results.txt
```

`results.txt` 파일 실행결과를 확인해보자.

```
$ cat results.txt

Book	First	Second	Ratio
abyss	4044	2807	1.44
isles	3822	2460	1.55
last	12244	5566	2.20
sierra	4242	2469	1.72
```

가장 빈도수가 높은 두 단어 출현비율이 지프의 법칙에서 예측했듯이 대략 2 근처다. 


다음에 최종 Makefile이 나와 있다:

```
include config.mk

TXT_FILES=$(wildcard books/*.txt)
DAT_FILES=$(patsubst books/%.txt, %.dat, $(TXT_FILES))

# Generate summary table.
results.txt : $(ZIPF_SRC) $(DAT_FILES)
	$(ZIPF_EXE) $(DAT_FILES) > $@

# Count words.
.PHONY : dats
dats : $(DAT_FILES)

%.dat : books/%.txt $(COUNT_SRC)
	$(COUNT_EXE) $< $@

.PHONY : clean
clean :
	rm -f $(DAT_FILES)
	rm -f results.txt

.PHONY : variables
variables:
	@echo TXT_FILES: $(TXT_FILES)
	@echo DAT_FILES: $(DAT_FILES)
```

`config.mk` 파일에 다음이 포함되어 있음을 기억하라:

```
# Count words script.
LANGUAGE=python
COUNT_SRC=countwords.py
COUNT_EXE=$(LANGUAGE) $(COUNT_SRC)

# Test Zipf's rule
ZIPF_SRC=testzipf.py
ZIPF_EXE=$(LANGUAGE) $(ZIPF_SRC)
```

`Makefile` 내부에 `results.txt` 타겟을 제작하는데 구현된 의존성을 다음 그래프가 보여주고 있다.
이를 통해 함수도 소개했다.

![함수를 도입한 후에 `results.txt` 의존성](assets/images/make/07-functions.png)

## 함수 요약 {#make-function-points}

* Make `wildcard` 함수를 사용해서 패턴과 매칭되는 파일 목록을 얻어온다.
* Make `patsubst` 함수를 사용해서 파일명을 다시 작성한다.


