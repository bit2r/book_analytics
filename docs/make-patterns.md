

# 패턴 규칙 {#make-patterns}

`Makefile`에는 여전히 반복되는 콘텐츠가 있다.
텍스트 파일과 데이터 파일 명칭을 제외하고 각 `.dat` 파일에 대한 규칙은 동일한다.
이러한 규칙을 단일 **패턴 규칙(pattern rule)**으로 
교체할 수 있는데, 패턴 규칙을 사용해서 `books/` 디렉토리에 `.txt` 파일을 임의 `.dat` 파일로 
빌드한다:

```
%.dat : books/%.txt countwords.py
	python countwords.py $< $*.dat
```

`%`는 Make **와일드-카드(wild-card)**다.
`$*`은 특수 변수로, 특수변수가 **스템(stem)**[^make-stemp]을 규칙이 매칭하는 것으로 치환한다.

[^make-stemp]: 스템은 패턴규칙으로 매칭되는 타겟의 일부. 만약 `file.dat`가 타겟이고
패턴 규칙이 `%.dat`인 경우 `$*` 스템은 `file` 이 된다.

상기 규칙은 다음과 같이 해석할 수 있다: `[something].dat` 타켓을 갖는 파일을 
빌드하는데 `books/[that same something].txt` 의존성을 갖는 파일을 찾아 
`countwords.py [the dependency] [the target]` 명령을 실행한다.

만약 Make를 다시 실행하면,

```
$ make clean
$ make dats
```

다음 결과를 얻게 된다:

```
python wordcount.py books/isles.txt isles.dat
python wordcount.py books/abyss.txt abyss.dat
python wordcount.py books/last.txt last.dat
```

이전과 마찬가지로 개별 `.dat` 타겟을 빌드하는데 `Make`를 여전히 사용할 수 있다.
어떤 스템이 매칭되더라도 신규 규칙은 여전히 정상동작한다.

::: {#make-wildcard .rmdcaution}

**Make 와일드-카드 사용하기**


Make `%` 와일드-카드는 대상과 해당 의존성에만 사용될 수 있다.
동작에는 사용될 수가 없다.

하지만, 동작에서 `$*`을 사용할 수 있는데, 스템이 규칙이 매칭하는 것으로 치환한다.
:::


Makefile은 이제 훨씬 더 짧아졌고, 깨끗해졌다:

```
# Generate summary table.
results.txt : testzipf.py isles.dat abyss.dat last.dat
	python $< *.dat > $@

# Count words.
.PHONY : dats
dats : isles.dat abyss.dat last.dat

%.dat : books/%.txt countwords.py
	python countwords.py $< $*.dat

.PHONY : clean
clean :
	rm -f *.dat
	rm -f results.txt
```

::: {#make-so-far-pattern .rmdcaution}

**현재까지 다룬 `Makefile`**

```
# Generate summary table.
results.txt : testzipf.py isles.dat abyss.dat last.dat
	python $< *.dat > $@

# Count words.
.PHONY : dats
dats : isles.dat abyss.dat last.dat

%.dat : books/%.txt countwords.py
	python countwords.py $< $*.dat

.PHONY : clean
clean :
	rm -f *.dat
	rm -f results.txt

```

:::

패턴 규칙을 소개했고 `dat` 규칙에 `$*`을 사용해서 사용법을 설명했다.
좀더 깔끔한 해법은 `$@`을 사용해서 현재 규칙의 타겟을 명세하는 것이지만
그러면 `$*`을 학습할 이유는 없을 것이다.

```
%.dat : books/%.txt countwords.py
	python countwords.py $< $@
```

## 패턴 규칙 주요점 {#make-patterns-points}

* Make 와일드-카드 `%`를 대상과 의존성에 사용한다.
* Make 특수 변수 `$*`을 동작에 사용한다.
* 규칙에는 Make 와일드-카드 사용을 회피한다.




