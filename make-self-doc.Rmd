

# 문서화 Makefile {#make-self-doc}

배쉬 내부에 실행되는 프로그램과 
개발자가 작성한 프로그램 포함하여 내장 배쉬 명령어는 
`--help` 플래그를 사용해서 프로그램과 명령어 사용법에 대한 정보를 전달하고 있다.
이런 연장선상에서 `help` 타겟을 `Makefiles` 내부에 작성해서 전달하는 것이
본인은 물론 다른 개발자에게도 도움이 된다.
이렇게 함으로써 주요 타겟에 대한 요약 정보와 동작방식에 대한 이해를 빠르게 높임으로써
꼭 필요하지 않는 경우 `Makefile`을 볼 필요는 없게 된다.
`help` 타겟을 실행하게 되면 다음이 출력된다. 

```
$ make help

results.txt : Generate Zipf summary table.
dats        : Count words in text files.
clean       : Remove auto-generated files.
```

그렇다면 구현하는 방법은 어떻게 될까? 다음과 같이 규칙을 작성하면 된다:

```
.PHONY : help
help :
	@echo "results.txt : Generate Zipf summary table."
	@echo "dats        : Count words in text files."
	@echo "clean       : Remove auto-generated files."
```

하지만 규칙을 매번 추가하거나 삭제, 혹은 규칙에 대한 설명을 변경할 때마다
이런 규칙도 수정해서 최신화시켜놔야 한다.
규칙 자체에 규칙에 대한 기술도 함께 유지하고 자동으로 추출하게 된다면 
정말 멋진 일이 될 것이다.

배쉬 쉘이 여기서 우리를 구원해줄 수 있다.
[`sed`][sed-docs] 명령어를 사용한다. `sed`는 `stream editor` 줄임말이다.
`sed`는 텍스트를 읽어 필터링하고 필터된 결과를 텍스트로 저장한다.

따라서, 규칙에 대한 주석도 함께 작성해서 나중에 
`sed`가 탐지할 수 있도록 표식을 남겨둔다.
`Make`는 `#`을 주석으로 사용하기 때문에 `sed`가 탐지할 수 있도록
`##` 표식을 대신 사용한다. 예를 들어,

```
## results.txt : Generate Zipf summary table.
results.txt : $(ZIPF_SRC) $(DAT_FILES)
	$(ZIPF_EXE) $(DAT_FILES) > $@

## dats        : Count words in text files.
.PHONY : dats
dats : $(DAT_FILES)

%.dat : books/%.txt $(COUNT_SRC)
	$(COUNT_EXE) $< $@

## clean       : Remove auto-generated files.
.PHONY : clean
clean :
	rm -f $(DAT_FILES)
	rm -f results.txt

## variables   : Print variables.
.PHONY : variables
variables:
	@echo TXT_FILES: $(TXT_FILES)
	@echo DAT_FILES: $(DAT_FILES)
```

`##` 표식을 사용해서 자동으로 `sed`가 필터하는 주석과 다른 규칙이 기술하는 주석을 
구별한다.

`Makefile` 파일에 `sed`를 적용한 `help` 타겟을 작성한다:


```
.PHONY : help
help : Makefile
	@sed -n 's/^##//p' $<
```

상기 규칙은 `Makefile` 자체에 의존한다.
`Makefile`에 적힌 첫번째 의존성으로 `sed`를 실행하고 `sed`에게 명령하여
`##`으로 시작되는 모든 행을 추출해서 `sed`가 출력하게 지정한다.

다음을 실행하게 되면

```
$ make help
```

다음을 얻게 된다.

```
 results.txt : Generate Zipf summary table.
 dats        : Count words in text files.
 clean       : Remove auto-generated files.
 variables   : Print variables.
```

타겟이나 규칙을 추가, 변경, 제거하게 되면
해당 규칙에 인접한 주석을 추가, 갱신, 제거하는 것만 기억하면 된다.
해당 작업에 대한 주석으로 `##` 관례만 존중하면 `help` 규칙이 자동으로 탐지하여
출력 도움말을 만들어낸다.


::: {#make-self-doc .rmdcaution}

**현재까지 다룬 `Makefile`**

```
include config.mk

TXT_FILES=$(wildcard books/*.txt)
DAT_FILES=$(patsubst books/%.txt, %.dat, $(TXT_FILES))

## results.txt : Generate Zipf summary table.
results.txt : $(ZIPF_SRC) $(DAT_FILES)
	$(ZIPF_EXE) $(DAT_FILES) > $@

## dats        : Count words in text files.
.PHONY : dats
dats : $(DAT_FILES)

%.dat : books/%.txt $(COUNT_SRC)
	$(COUNT_EXE) $< $@

## clean       : Remove auto-generated files.
.PHONY : clean
clean :
	rm -f $(DAT_FILES)
	rm -f results.txt

## variables   : Print variables.
.PHONY : variables
variables:
	@echo TXT_FILES: $(TXT_FILES)
	@echo DAT_FILES: $(DAT_FILES)

.PHONY : help
help : Makefile
	@sed -n 's/^##//p' $<


```

**`config.mk` 파일**

```
# Count words script.
LANGUAGE=python
COUNT_SRC=countwords.py
COUNT_EXE=$(LANGUAGE) $(COUNT_SRC)

# Test Zipf's rule
ZIPF_SRC=testzipf.py
ZIPF_EXE=$(LANGUAGE) $(ZIPF_SRC)

```

:::


[sed-docs]: https://www.gnu.org/software/sed/


