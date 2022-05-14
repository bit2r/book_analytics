

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

![이미지가 추가된 후 `all` 타겟 의존성](assets/images/make/09-conclusion-challenge-1.png)



