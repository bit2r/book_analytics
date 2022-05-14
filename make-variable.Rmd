

# 변수 {#make-variable}


지금까지의 노력에도 불구하고, Makefile에는 여전히 중복된 콘텐트, 즉 `countwords.py`
스크립트 명칭과 스크립트를 실행하는데 동원된 프로그램 `python`이 존재한다. 
해당 스크립트의 이름을 바꾸면, 여러 곳에서 Makefile을 갱신해야만 된다.

스크립트 명칭을 보관하는 Make **변수(variable)** (Make 일부 버젼에서는 **매크로(macro)**라고도 불림)를 소개한다:

```
COUNT_SRC=countwords.py
```

변수 **할당(assignment)**하는 예제가 위에 나와 있다 -
`COUNT_SRC` 변수에 `countwords.py` 값이 할당되었다.

`countwords.py`는 스크립트로, 파이썬(`python`)에 전달되어 호출된다.
또다른 변수를 도입해서 스크립트 실행을 표현한다:

```
LANGUAGE=python
COUNT_EXE=$(LANGUAGE) $(COUNT_SRC)
```

Make가 실행될 때, `$(...)`는 Make에게 변수를 해당 값으로 치환하도록 일러준다.
이것이 변수 **참조(reference)**다.
변수값을 사용하고자 하는 어떤 곳에서도, 이런 방식으로 작성하고 참조한다.

여기서는 `COUNT_SRC` 변수를 참조한다.
Make로 하여금 `COUNT_SRC` 변수를 `countwords.py` 값으로 치환하게 한다.
Make가 실행될 때, `COUNT_EXE`에 값으로 `python countwords.py`를 할당한다.

이런 방식으로 `COUNT_EXE` 변수를 정의하면 스크립트 실행방식을 쉽게 변경할 수 있게 된다
(예를 들어, 스크립트 구현 언어를 파이썬에서 R로 변경하게 되면).

::: {#make-variable-use .rmdcaution}

**변수 사용하기**

`Makefile`를 갱신해서, `%.dat` 규칙이
`COUNT_SRC` 와 `COUNT_EXE` 변수를 참조하게 한다.
그리고 나서 `ZIPF_SRC` 와 `ZIPF_EXE` 변수명을 사용해서
`testzipf.py` 스크립트와 `results.txt` 규칙에 대해서도 동일하게 작업한다.

> **해답**
> 
> ```
> LANGUAGE=python
> COUNT_SRC=countwords.py
> COUNT_EXE=$(LANGUAGE) $(COUNT_SRC)
> ZIPF_SRC=testzipf.py
> ZIPF_EXE=$(LANGUAGE) $(ZIPF_SRC)
> 
> # Generate summary table.
> results.txt : $(ZIPF_SRC) isles.dat abyss.dat last.dat
> 	$(ZIPF_EXE) *.dat > $@
> 
> # Count words.
> .PHONY : dats
> dats : isles.dat abyss.dat last.dat
> 
> %.dat : books/%.txt $(COUNT_SRC)
> 	$(COUNT_EXE) $< $*.dat
> 
> .PHONY : clean
> clean :
> 	rm -f *.dat
> 	rm -f results.txt
> ```

:::

Makefile 상단에 변수를 위치시키게 되면, 찾고 변경하기 쉽게 한다는 의미가 된다.
대안으로, 변수 정보만 간직하는 Makefile을 새로 만들어 넣을 수 있다.
`config.mk` 파일을 생성하자:

```
# Count words script.
LANGUAGE=python
COUNT_SRC=countwords.py
COUNT_EXE=$(LANGUAGE) $(COUNT_SRC)

# Test Zipf's rule
ZIPF_SRC=testzipf.py
ZIPF_EXE=$(LANGUAGE) $(ZIPF_SRC)
```

다음 명령어를 사용해서, `config.mk` 파일을 `Makefile` 내부로 Makefile을 가져올 수 있다:

```
include config.mk
```

Make를 재실행해서, 모든 것이 여전히 잘 동작하는지 살펴보자:

```
$ make clean
$ make dats
$ make results.txt
```

Makefile 구성정보와 작업을 수행하는 부분, 즉 규칙을 구분했다.
스크립트 명칭 혹은 실행방식을 변경하려면, 
`Makefile`에 있는 소스코드가 아니라, 단지 구성파일만 편집하면 된다.
이런 방식으로 코드를 구성과 결합시키지 않는 것이 좋은 프로그래밍 관례다.
더 모듈화 되고, 유연해지며, 재사용가능한 코드가 되기 때문이다.


::: {#make-so-far .rmdcaution}

**현재까지 다룬 `Makefile`**

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

**새로 추가된 config 파일**

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


