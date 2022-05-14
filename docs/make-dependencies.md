

# 데이터와 코드 의존성 {#make-dependencies}

지금까지 작성한 Makefile은 다음과 같다:

```
# Count words.
.PHONY : dats
dats : isles.dat abyss.dat last.dat

isles.dat : books/isles.txt
	python wordcount.py $< $@

abyss.dat : books/abyss.txt
	python wordcount.py $< $@

last.dat : books/last.txt
	python wordcount.py $< $@

# Generate archive file.
analysis.tar.gz : *.dat
	tar -czf $@ $^

.PHONY : clean
clean :
        rm -f *.dat
        rm -f analysis.tar.gz
```

데이터 파일은 텍스트 파일에 대한 제품이기도 하지만,
텍스트 파일을 처리하고 데이터 파일을 생성하는 `countwords.py`, 스크립트에 대한 제품이기도 하다.
`countwords.py` 파일 수정(예를 들어 요약 데이터 신규 칼럼 추가 혹은 기존 요약결과 제거 등)은 
출력결과를 `.dat` 파일변경에도 일조를 하게 된다.
따라서, `touch` 명령어를 사용해서 `countwords.py` 파일을 수정한 것처럼 하고 
`Make`를 다시 실행시키자.

```
$ make dats
$ touch countwords.py
$ make dats
```

아무런 일도 발생하지 않았다! 
`countwords.py` 파일을 수정했지만, 데이터 파일을 갱신하지 않아서
`.dat` 파일 생성에 관여하는 규칙이 `countwords.py` 파일 의존성을 기록하지 못했다.

또한, `countwords.py` 파일을 데이터 파일에 대한 의존성으로 추가해야만 된다:

```
isles.dat : books/isles.txt countwords.py
	python countwords.py $< $@

abyss.dat : books/abyss.txt countwords.py
	python countwords.py $< $@

last.dat : books/last.txt countwords.py
	python countwords.py $< $@
```

`wordcount.py` 프로그램을 편집한 척하고, Make를 재실행하면, 

```
$ touch wordcount.py
$ make dats
```

다음 결과를 얻게 된다:

```
python countwords.py books/isles.txt isles.dat
python countwords.py books/abyss.txt abyss.dat
python countwords.py books/last.txt last.dat
```

::: {#make-dry-run .rmdcaution}

**시운전 (Dry Run)**

`make` 명령어를 실행할 때 `-n` 플래그를 사용하게 되면
실제 명령을 실행하지 않고 실행할 명령어를 보여준다.

```
$ touch countwords.py
$ make -n dats
```

`-n` 플래그 없이 화면에 동일한 출력결과를 보여주지만,
실제 명령은 실행되지 않는다. 'dry-run' 모드를 사용해서
실제 돌리지 건에 `Makefile`이 제대로 설정되었는지 사전
확인할 수 있다.
:::


`countwords.py`와 `testzipf.py` 파일을 `.dat` 파일에 의존성으로 추가한 후,
`results.txt`에 명기된 대상을 빌드하는데 관여된 의존성을 도식화했는데, 
Makefile에서 구현된 사항이 다음 그림에 나와 있다:


![`countwords.py`와 `testzipf.py` 파일을 의존성으로 추가한 후에, `results.txt` 의존성](assets/images/make/04-dependencies.png)


::: {#make-wordcoutn .rmdcaution}

**`.txt` 파일은 `wordcount.py` 파일에 의존성을 갖지 않는가?**

`.txt` 파일은 입력 파일이며 어떤 의존성도 갖지 않는다.
입력파일이 `wordcount.py` 파일에 의존성을 만드려면,
**거짓 의존성(false dependency)**
도입이 필요하다.
:::

직관적으로 `results.txt` 파일에 의존성을 `countwords.py` 파일에 추가해야 한다.
`.dat` 파일을 다시 만드는데 최종표가 빌드되야 하기 때문이다.
하지만 그럴필요가 없다는 것이 밝혀졌다. `countwords.py` 파일을 갱신할 때
`results.txt` 파일에 생긴 일을 살펴보자.

```
$ touch countwords.py
$ make results.txt
```

상기 명령을 실행하면 다음을 얻게 된다.

```
python countwords.py books/abyss.txt abyss.dat
python countwords.py books/isles.txt isles.dat
python countwords.py books/last.txt last.dat
python testzipf.py abyss.dat isles.dat last.dat > results.txt
```

`results.txt` 파일 파일 포함해서 전체 파이프라인이 촉발되어 실행되었다.
이 과정을 이해하기 위해 의존성 그래프에 따르면 `results.txt` 파일은 
`.dat` 파일에 의존성을 갖는다. 
`countwords.py` 파일을 갱신하게 되면 `.dat` 파일 갱신을 촉발시킨다.
따라서, `make`가 `.dat` 파일 의존성이 `results.txt` 타겟 파일보다 
신규 상태임을 인식하게 되어 `results.txt` 파일을 다시 만들어낸다.
이것이 `make`의 강력함을 보여주는 한 사례다: 파이프라인의 일부 파일이 갱신되면
적절한 후속 단계를 자동 실행시킨다.

## 입력파일 갱신 {#make-one-file}

다음 명령을 실행시키게 되면 어떤 결과가 나오게 될까?

```
$ touch books/last.txt
$ make results.txt
```

1. `last.dat` 파일만 다시 생성된다.
2. 모든 `.dat`확장자를 갖는 파일이 다시 생성된다.
3. `last.dat`, `results.txt` 파일만 다시 생성된다.
4. 모든 `.dat`, `results.txt` 파일만 다시 생성된다.

> **해답**
> 3. `last.dat`, `results.txt` 파일만 다시 생성된다.
> 
> 의존성 나무그래프를 따라가면 정답이 명확하게 이해된다.

## `results.txt` 의존성 `testzipf.py` {#make-testzipf}

`results.txt` 파일 의존성에 `testzipf.py` 파일을 추가하면 어떻게 될까? 
그리고 이유는 무엇일까?


> **해답**
>
> 다음과 같이 `results.txt` 파일에 규칙을 추가하게 되면 
>
> ```
> results.txt : isles.dat abyss.dat last.dat testzipf.py
>         python testzipf.py $^ > $@
> ```
>
>
> `testzipf.py` 는 `$^`의 일부가 되어 명령어는 사실 다음과 같이 된다.
>
> ```
> python testzipf.py abyss.dat isles.dat last.dat testzipf.py > results.txt
> ```
>
> `testzipf.py` 파일에서 `.dat` 파일처럼 스크립트를 파싱하게 되어 오류가 발생한다.
> 오류가 나온 것을 실제로 돌려 확인해보자.
>  
> ```
> $ make results.txt
> ```
>
> 다음과 같은 결과가 나오게 된다.
>
> ```
> python testzipf.py abyss.dat isles.dat last.dat testzipf.py > results.txt
> Traceback (most recent call last):
>   File "testzipf.py", line 19, in <module>
>     counts = load_word_counts(input_file)
>   File "path/to/testzipf.py", line 39, in load_word_counts
>     counts.append((fields[0], int(fields[1]), float(fields[2])))
> IndexError: list index out of range
> make: *** [results.txt] Error 1
> ```

`results.txt` 파일에 대한 의존성에 `testzipf.py` 스크립트를 반영해야 된다.
앞선 사례를 통해 `$^` 규칙을 사용할 수는 없다는 것이 확인되었다.
하지만, `testzipf.py` 파일을 첫번째 의존성으로 이동하고 나서 
`$<`을 사용해서 참조하면 된다. `.dat` 파일을 지칭하는데는 
임시로 `*.dat`를 사용한다.(추후 더 좋은 해법을 다룰 것이다.)


```
results.txt : testzipf.py isles.dat abyss.dat last.dat
	python $< *.dat > $@
```

::: {#make-so-far .rmdcaution}

**현재까지 다룬 `Makefile`**

```
# Generate summary table.
results.txt : testzipf.py isles.dat abyss.dat last.dat
	python $< *.dat > $@

# Count words.
.PHONY : dats
dats : isles.dat abyss.dat last.dat

isles.dat : books/isles.txt countwords.py
	python countwords.py $< $@

abyss.dat : books/abyss.txt countwords.py
	python countwords.py $< $@

last.dat : books/last.txt countwords.py
	python countwords.py $< $@

.PHONY : clean
clean :
	rm -f *.dat
	rm -f results.txt
```

:::
