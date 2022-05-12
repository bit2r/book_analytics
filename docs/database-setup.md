
# SQLite 설치 {#database-sqlite}


이번 학습은 다음 장에서 사용되는 예제 데이터베이스를 어떻게 설치하는지 설명한다.
다음의 지도사항을 따르기 위해서는 명령-라인을 사용하여 어떻게 디렉토리를 여기저기 이동하는지와 명령-라인에서 명령문을 어떻게 실행하는지 숙지할 필요가 있다.
이런 주제와 친숙하지 않다면, **유닉스 쉘(Unix Shell)** 학습을 참조하세요.
이후의 장에서 데이터베이스를 어떻게 생성하고 데이터를 채우는지 배울 것이지만, 먼저 SQLite 데이터베이스가 어떻게 동작하는지 설명을 할 필요가 있어서
데이터베이스를 선행하여 제공한다.


## 설치 {#sqlite-install}


인터랙티브하게 다음 학습을 수행하기 위해서는 [설치 방법](http://software-carpentry.org/v5/setup.html)에 언급된 SQLite 를 참조하여 설치하세요.

그리고 , 여러분이 선택한 위치에 "software_carpentry_sql" 디렉토리를 생성하세요.예를 들어


1) 명령 라인 터미널 윈도우를 여세요.

2) 다음과 같이 타이핑한다.

```
mkdir ~/swc/sql
```

3) 생성한 디렉토리로 현재 작업 디렉토리를 변경한다.

```
cd ~/swc/sql
```

## SQLite 설치 [^install-sqlite3] {#install-sqlite}

[^install-sqlite3]: [SQLite3 설치 및 간단한 사용법](http://blog.simplism.kr/?p=2329)

[SQLite Download Page](http://sqlite.org/download.html)에서 [sqlite-tools-win32-x86-3200000.zip](http://sqlite.org/2017/sqlite-tools-win32-x86-3200000.zip)을 다운로드 받는다.
압축을 풀면 황당하게 몇개 `.exe` 파일이 존재하는 황당함을 느낀다. 설치가 완료되었다.


```r
$ ls
gen-survey-database.sql  sqlite3.exe           survey.db
sqldiff.exe              sqlite3_analyzer.exe
```

- sqlite3.exe: sqlite 실행파일
- gen-survey-database.sql: `survey.db` sqlite 데이터베이스를 생성시키는데 사용되는 스크립트
- survey.db: `sqlite3.exe` 명령어를 실행해서 `gen-survey-database.sql` 스크립트를 통해 생성된 데이터베이스


## 실습 데이터베이스 다운로드 {#download-database}

`깃헙(GitHub)`에서 `gen-survey-database.sql` 파일을 어떻게 다운로드 받을까요?

`~/swc/sql` 디렉토리로 이동한 후에 그 디렉토리에서 
GitHub 사이트 [https://github.com/swcarpentry/bc/blob/master/novice/sql/gen-survey-database.sqlSQL](https://github.com/swcarpentry/bc/blob/master/novice/sql/gen-survey-database.sqlSQL)에 
위치한 SQL 파일("gen-survey-database.sql")을 다운로드한다.

파일이 GitHub 저장소 내에 위치하고 있어서, 전체 Git 저장소(git repo)를 복제(cloning)하지 않고 단일 파일만 로컬로 가져온다. 
이 목적을 달성하기 위해서,
HTTP, HTTPS, FTP 프로토콜을 지원하는 명령-라인 웹크롤러(web-crawler) 소프트웨어 [GNU Wget](http://en.wikipedia.org/wiki/Wget) 혹은, 
다양한 프로토콜을 사용하여 데이터를 전송하는데 사용되는 라이브러리이며 명령-라인 도구인 [cURL](http://en.wikipedia.org/wiki/CURL)을 사용한다.
두가지 도구 모두 크로스 플랫폼(cross platform)으로 다양한 운영체제를 지원한다.

`Wget` 혹은 `cURL`을 로컬에 설치한 후에, 터미널에서 다음 명령어를 실행한다.

**Tip:** 만약 `cURL`을 선호한다면, 다음 명령문에서 "wget"을 `curl -O`로 대체하세요.


```r
root@hangul:~/swc/sql$ wget https://raw.githubusercontent.com/swcarpentry/bc/master/novice/sql/gen-survey-database.sql
```

상기 명령문으로 Wget은 HTTP 요청을 생성해서 github 저장소의 "gen-survey-database.sql" 원파일만 현재 작업 디렉토리로 가져온다.

성공적으로 완료되면 터미널은 다음 출력결과를 화면에 표시한다.


```r
--2014-09-02 18:31:43--  https://raw.githubusercontent.com/swcarpentry/bc/master/novice/sql/gen-survey-database.sql
Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 103.245.222.133
Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|103.245.222.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 3297 (3.2K) [text/plain]
Saving to: ‘gen-survey-database.sql’

100%[=========================================================================================================================&gt;] 3,297       --.-K/s   in 0.01s   

2014-09-02 18:31:45 (264 KB/s) - ‘gen-survey-database.sql’ saved [3297/3297]
```

이제 성공적으로 단일 SQL 파일을 가져와서, 
`survey.db` 데이터베이스를 생성하고 
`gen-survey-database.sql` 에 저장된 지시방법에 따라서 데이터를 채워넣는다.

명령-라인 터미널에서 SQLite3 프로그램을 호출하기 위해서, 다음 명령문을 실행한다.


```r
root@hangul:~/swc/sql$ sqlite3 survey.db < gen-survey-database.sql
```

## SQLite DB 연결/설치 테스트 {#connect-sqlite}

생성된 데이터베이스에 연결하기 위해서, 
데이터베이스를 생성한 디렉토리 안에서 SQLite를 시작한다. 
그래서 `~/swc/sql` 디렉토리에서 다음과 같이 타이핑한다.


```r
root@hangul:~/swc/sql$ sqlite3 survey.db
```

`sqlite3 survey.db` 명령문이 데이터베이스를 열고 데이터베이스 명령-라인 프롬프트로 안내한다. 
SQLite에서 데이터베이스는 플랫 파일(flat file)로 명시적으로 열 필요가 있다. 
그리고 나서 SQLite 시작되고 `sqlite`로 명령-라인 프롬프트가 다음과 같이 변경되어 표시된다.



```r
SQLite version 3.20.0 2017-08-01 13:24:15
Enter ".help" for usage hints.
Connected to a transient in-memory database.
Use ".open FILENAME" to reopen on a persistent database.
sqlite>  
```

다음 출력결과가 보여주듯이 `.databases` 명령문으로 소속된 데이터베이스 이름과 파일 목록을 확인한다.


```r
sqlite> .databases
seq  name             file                                                      
---  ---------------  ----------------------------------------------------------
0    main             ~/novice/sql/survey.db
```

다음과 같이 타이핑해서 필요한 "Person", "Survey", "Site" "Visited" 테이블이 존재하는 것을 확인한다.
`.table`의 출력결과는 다음과 같다.


```r
sqlite> .tables
Person   Site     Survey   Visited
```



## SQLite DB 나오는 법 {#sqlite-escape}

SQLite3 DB 명령-라인 인터페이스(CLI)를 어떻게 빠져나올까요?

SQLite3를 빠져나오기 위해서, 다음과 같이 타이핑한다.

```
sqlite> .quit
```


