

# 결론 {#make-conclusion}

Make 같은 자동 빌드 도구는 여러가지 방식으로 도움을 줄 수 있다.
반복되는 명령어를 자동화해서, 명령어를 수작업으로 실행할 때,
범하게 되는 오류위험을 줄여 주고, 시간을 절약해서 도움이 된다.

생성할 파일이 어떤 방식으로 변경될 때,
자동적으로 생성되는 산출물(데이터 파일 혹은 그래프)만 다시 생성하게 함으로써
시간을 절약해준다.

대상, 의존성, 동작 개념을 통해,
코드, 스크립트, 도구, 구성(configuration), 원데이터, 
파생된 데이터, 그래프, 논문 사이 의존성을 기록하는 문서화 형태로 역할을 수행한다.

## PNG 생성하기 {#make-conclusion-png}

새로운 규칙을 추가하고, 기존 규칙을 갱신하고, 매크로를 새로 추가하여 다음 작업을 수행한다:

* `plotcounts.py` 프로그램을 사용해서 `.dat` 파일에서 `.png` 파일을 생성한다.
* 자동생성된 모든 파일(`.dat`, `.jpg`, `results.txt`)을 제거한다. 

대다수 `Makefile`은 첫번째 `all` 타겟으로 디폴트 기본 포니 타겟을 정의한다.
`all` 타겟을 이번 경우 `.png` 파일과 `results.txt` 파일을 빌드하는 작업을 수행한다.
`Makefile`은 관례를 따라 `all` 타겟을 지원한다.
따라서, `make results.txt` 실행하는 대신 `make all` 혹은 더 줄여 `make` 명령어를 
실행해야 된다. 기본디폴트 설정으로 `Makefile`에서 첫번째 타겟을 찾아 실행하게 만든다.
이번 경우 `all` 타겟이다.

> **Makefile**
> 
> ```
> include config.mk
> 
> TXT_FILES=$(wildcard books/*.txt)
> DAT_FILES=$(patsubst books/%.txt, %.dat, $(TXT_FILES))
> PNG_FILES=$(patsubst books/%.txt, %.png, $(TXT_FILES))
> 
> ## all         : Generate Zipf summary table and plots of word counts.
> .PHONY : all
> all : results.txt $(PNG_FILES)
> 
> ## results.txt : Generate Zipf summary table.
> results.txt : $(ZIPF_SRC) $(DAT_FILES)
> 	$(ZIPF_EXE) $(DAT_FILES) > $@
> 
> ## dats        : Count words in text files.
> .PHONY : dats
> dats : $(DAT_FILES)
> 
> %.dat : books/%.txt $(COUNT_SRC)
> 	$(COUNT_EXE) $< $@
> 
> ## pngs        : Plot word counts.
> .PHONY : pngs
> pngs : $(PNG_FILES)
> 
> %.png : %.dat $(PLOT_SRC)
> 	$(PLOT_EXE) $< $@
> 
> ## clean       : Remove auto-generated files.
> .PHONY : clean
> clean :
> 	rm -f $(DAT_FILES)
> 	rm -f $(PNG_FILES)
> 	rm -f results.txt
> 
> ## variables   : Print variables.
> .PHONY : variables
> variables:
> 	@echo TXT_FILES: $(TXT_FILES)
> 	@echo DAT_FILES: $(DAT_FILES)
> 	@echo PNG_FILES: $(PNG_FILES)
> 
> .PHONY : help
> help : Makefile
> 	@sed -n 's/^##//p' $<
> 
> ```
> 
> **config.mk**
> 
> ```
> # Count words script.
> LANGUAGE=python
> COUNT_SRC=countwords.py
> COUNT_EXE=$(LANGUAGE) $(COUNT_SRC)
> 
> # Plot word counts script.
> PLOT_SRC=plotcounts.py
> PLOT_EXE=$(LANGUAGE) $(PLOT_SRC)
> 
> # Test Zipf's rule
> ZIPF_SRC=testzipf.py
> ZIPF_EXE=$(LANGUAGE) $(ZIPF_SRC)
> 
> ```

![이미지가 추가된 후 `all` 타겟 의존성](assets/images/make/09-conclusion-challenge-1.png){width=100%}



## 아카이브 생성 {#make-conclusion-archive}

데이터, 코드, 결과가 모두 포함된 프로젝트를 담은 아카이브를 생성하면 유용하다.
많은 파일을 담아 패키지로 묶어 하나의 파일로 제작한
아카이브 파일(Archive file)은 다른 협업하시는 분과 쉽게 공유할 수 있고 다운로드
받기도 편하다. `Makefile` 자체 내부에 아카이브 생성 단계를 추가함으로써
프로젝트가 변경되더라도 아카이브 파일을 쉽게 갱신하여 최신화시킬 수 있다.

`Makefile` 파일을 편집해서 프로젝트 아카이브 파일을 생성한다.
규칙을 새로 추가하고, 변경해서, 새로운 변수도 추가해서 다음 작업을 수행하게 만든다.

* 프로젝트 디렉토리에 `zipf_analysis` 폴더를 새로 생성한다.
* 코드, 데이터, 그래프, 지프의 법칙 요약 표, `Makefile`, `config.mk` 모든 파일을
해당 디렉토리로 복사한다. `cp -r` 명령어를 사용해서 모든 파일과 디렉토리를 새로 
생성한 `zipf_analysis` 디렉토리에 복사한다.

```
$ cp -r [files and directories to copy] zipf_analysis/
```

* 힌트: `books` 디렉토리에 변수를 새로 생성한다. `zipf_analysis` 디렉토리에 복사한다.
* `zipf_analysis.tar.gz` 아카이브를 생성한다. `tar` 배쉬 명령어를 다음과 같이 사용한다.

```
$ tar -czf zipf_analysis.tar.gz zipf_analysis
```

* `all` 타겟을 업데이트해서 `zipf_analysis.tar.gz` 파일을 생성한다.
* `make clean`이 호출되면 `zipf_analysis.tar.gz` 파일을 제거한다.
* `make variables`를 호출하게 되면 정의한 추가 변수 값을 출력한다.

> **`Makefile` 해답**
> 
> ```
> include config.mk
> 
> TXT_DIR=books
> TXT_FILES=$(wildcard $(TXT_DIR)/*.txt)
> DAT_FILES=$(patsubst $(TXT_DIR)/%.txt, %.dat, $(TXT_FILES))
> PNG_FILES=$(patsubst $(TXT_DIR)/%.txt, %.png, $(TXT_FILES))
> RESULTS_FILE=results.txt
> ZIPF_DIR=zipf_analysis
> ZIPF_ARCHIVE=$(ZIPF_DIR).tar.gz
> 
> ## all         : Generate archive of code, data, plots, summary table, Makefile, and config.mk.
> .PHONY : all
> all : $(ZIPF_ARCHIVE)
> 
> $(ZIPF_ARCHIVE) : $(ZIPF_DIR)
> 	tar -czf $@ $<
> 
> $(ZIPF_DIR): Makefile config.mk $(RESULTS_FILE) \
>              $(DAT_FILES) $(PNG_FILES) $(TXT_DIR) \
>              $(COUNT_SRC) $(PLOT_SRC) $(ZIPF_SRC)
> 	mkdir -p $@
> 	cp -r $^ $@
> 	touch $@
> 
> ## results.txt : Generate Zipf summary table.
> $(RESULTS_FILE) : $(ZIPF_SRC) $(DAT_FILES)
> 	$(ZIPF_EXE) $(DAT_FILES) > $@
> 
> ## dats        : Count words in text files.
> .PHONY : dats
> dats : $(DAT_FILES)
> 
> %.dat : $(TXT_DIR)/%.txt $(COUNT_SRC)
> 	$(COUNT_EXE) $< $@
> 
> ## pngs        : Plot word counts.
> .PHONY : pngs
> pngs : $(PNG_FILES)
> 
> %.png : %.dat $(PLOT_SRC)
> 	$(PLOT_EXE) $< $@
> 
> ## clean       : Remove auto-generated files.
> .PHONY : clean
> clean :
> 	rm -f $(DAT_FILES)
> 	rm -f $(PNG_FILES)
> 	rm -f $(RESULTS_FILE)
> 	rm -rf $(ZIPF_DIR)
> 	rm -f $(ZIPF_ARCHIVE)
> 
> ## variables   : Print variables.
> .PHONY : variables
> variables:
> 	@echo TXT_DIR: $(TXT_DIR)
> 	@echo TXT_FILES: $(TXT_FILES)
> 	@echo DAT_FILES: $(DAT_FILES)
> 	@echo PNG_FILES: $(PNG_FILES)
> 	@echo ZIPF_DIR: $(ZIPF_DIR)
> 	@echo ZIPF_ARCHIVE: $(ZIPF_ARCHIVE)
> 
> .PHONY : help
> help : Makefile
> 	@sed -n 's/^##//p' $<
> ```
> 
> **`config.mk` 해답**
> 
> ```
> # Count words script.
> LANGUAGE=python
> COUNT_SRC=countwords.py
> COUNT_EXE=$(LANGUAGE) $(COUNT_SRC)
> 
> # Plot word counts script.
> PLOT_SRC=plotcounts.py
> PLOT_EXE=$(LANGUAGE) $(PLOT_SRC)
> 
> # Test Zipf's rule.
> ZIPF_SRC=testzipf.py
> ZIPF_EXE=$(LANGUAGE) $(ZIPF_SRC)
> 
> ```

## `Makefile` 아카이빙 {#make-conclusion-makefile}


아카이브 디렉토리에 대한 `Makefile` 규칙에 
`Makefile`을 코드, 데이터, 그래프, 지프의 요약표에 추가될까?

> **해답**
> 
> `countwords.py`, `plotcounts.py`, `testzipf.py` 코드 파일은
> 작업흐름의 개별 부분을 담고 있다.
> 코드 파일을 통해서 `.txt` 파일에서 `.dat` 파일을 생성해낸다.
> 그리고, `.dat` 파일에서 `.png` 파일과 `results.txt` 파일을 만들어낸다.
> 하지만 `Makefile`에는 코드파일, 원데이터, 파생데이터, 그래프를 비롯한
> 전체 작업흐름이 문서로 담겨있다.
> `config.mk` 파일은 `Makefile`에 대한 환경설정 정보도 담겨있어 아카이브로 
> 저장되어야 한다.


## 아카이브 디렉토리 `touch` {#make-conclusion-touch}

코드, 데이터, 그래프, 요약표를 아카이브 디렉토리로 이동시킨 후에
아카이브 디렉토리에 `Makefile` 규칙을 왜 `touch`해야 할까?

> **해답**
> 
> 파일이 아카이브 디렉토리로 복사될 때 디렉토리 시간도장이 자동으로 갱신되지 않는다.
> 만약 코드, 데이터, 그래프, 요약표를 아카이브 디렉토리로 최신화되어 복사되면,
> `touch` 명령어로 아카이브 디렉토리 시간도장이 최신으로 갱신되어야 한다.
> 그래야만 규칙이 `zipf_analysis.tar.gz` 파일을 다시 실행시켜 제작시키는 것을 알게 된다.
> `touch`가 없다면 `zipf_analysis.tar.gz` 파일은 규칙이 처음 실행될 때 생성되고
> 아카이브 디렉토리 콘텐츠가 변경되더라도 후속 변경작업을 일어나지 않게 된다.
