
# 파이프와 필터{#pipe-filter}

몇가지 기초 유닉스 명령어를 배웠기 때문에, 
마침내 쉘의 가장 강령한 기능을 살펴볼 수 있게 되었다: 
새로운 방식으로 기존에 존재하던 프로그램을 쉽게 조합해 낼 수 있게 한다. 
간단한 유기분자 설명을 하는 6개 파일을 담고 있는 `molecules`(분자)라는 디렉토리에서 시작한다. 
`.pdb` 파일 확장자는 단백질 데이터 은행 (Protein Data Bank) 형식으로, 
분자의 각 원자 형식과 위치를 표시하는 간단한 텍스트 형식으로 되어 있다.

```
$ ls molecules
cubane.pdb    ethane.pdb    methane.pdb
octane.pdb    pentane.pdb   propane.pdb
```


명령어 `cd`로 해당 디렉토리로 가서 `wc *.pdb` 명령어를 실행한다. 
`wc` 명령어는 "word count"의 축약어로 파일의 라인 수, 단어수, 문자수를 개수한다. (왼쪽에서 오른쪽 순서로)

`*.pdb`에서 `*`은 0 혹은 더 많이 일치하는 문자를 매칭한다.
그래서 쉘은 `*.pdb`을 통해 `.pdb` 전체 리스트 목록을 반환한다:


```
$ cd molecules
$ wc *.pdb

  20  156  1158  cubane.pdb
  12  84   622   ethane.pdb
   9  57   422   methane.pdb
  30  246  1828  octane.pdb
  21  165  1226  pentane.pdb
  15  111  825   propane.pdb
 107  819  6081  total
```



`wc` 대신에 `wc -l`을 실행하면, 출력결과는 파일마다 행수만을 보여준다:

```
$ wc -l *.pdb

  20  cubane.pdb
  12  ethane.pdb
   9  methane.pdb
  30  octane.pdb
  21  pentane.pdb
  15  propane.pdb
 107  total
```

단어 숫자만을 얻기 위해서 `-w`, 문자 숫자만을 얻기 위해서 `-c`을 사용할 수 있다.

파일 중에서 어느 파일이 가장 짧을까요? 
단지 6개의 파일이 있기 때문에 질문에 답하기는 쉬울 것이다. 
하지만 만약에 6000 파일이 있다면 어떨까요? 
해결에 이르는 첫번째 단계로 다음 명령을 실행한다:

```
$ wc -l *.pdb > lengths.txt
```

`>` 기호는 쉘로 하여금 화면에 처리 결과를 뿌리는 대신에 파일로 **방향변경(redirect)**하게 한다. 
만약 파일이 존재하지 않으면 파일을 생성하고 파일이 존재하면 파일에 내용을 덮어쓰기 한다. 
조용하게 덮어쓰기 하기 때문에 자료가 유실될 수 있어서 주의가 요구된다.
(이것이 왜 화면에 출력결과가 없는 이유다. `wc`가 출력하는 모든 것은 `lengths.txt` 파일에 대신 들어간다.) 
`ls lengths.txt` 을 통해 파일이 존재하는 것을 확인한다:

```
$ ls lengths.txt

lengths.txt
```

`cat lengths.txt`을 사용해서 화면으로 `lengths.txt`의 내용을 보낼 수 있다. 
`cat`은 "concatenate"를 줄인 것이고 하나씩 하나씩 파일의 내용을 출력한다. 
이번 사례에는 단지 파일이 하나만 있어서, `cat` 명령어는 단지 한 파일이 담고 있는 내용만 보여준다:

```
$ cat lengths.txt

  20  cubane.pdb
  12  ethane.pdb
   9  methane.pdb
  30  octane.pdb
  21  pentane.pdb
  15  propane.pdb
 107  total
```

::: {#shell-pipefilter-page .rmdcaution}

**페이지 단위 출력결과 살펴보기**

이번 학습에서 편리성과 일관성을 위해서 `cat` 명령어를 계속 사용한다.
하지만, 파일 전체를 화면에 쭉 뿌린다는 면에서 단점이 있다.
실무적으로 `less` 명령어가 더 유용한데 `$ less lengths.txt`와 같이 사용한다.
파일을 화면 단위로 출력한다.
아래로 내려가려면 스페이스바를 누르고, 뒤로 돌아가려면 `b`를 누르면 되고,
빠져 나가려면 `q`를 누른다.

:::

이제 `sort` 명령어를 사용해서 파일 내용을 정렬합니다. 

::: {#shell-pipefilter-sort .rmdcaution}

**`sort -n` 명령어는 어떤 작업을 수행할까?**

다음 파일 행을 포함하고 있는 파일에 `sort` 명령어를 실행하면:

```
10
2
19
22
6
```

출력결과는 다음과 같다:

```
10
19
2
22
6
```

동일한 입력에 대해서 `sort -n`을 실행하면, 대신에 다음 결과를 얻게 된다:

```
2
6
10
19
22
```

인수 `-n`이 왜 이런 효과를 가지는지 설명하세요.

> **해답**
>
> `-n` 플래그는 알파벳 정렬이 아닌, 숫자 정렬하도록 명세한다.

:::

`-n` 플래그를 사용해서 알파벳 대신에 숫자 방식으로 정렬할 것을 지정할 수 있다.
이 명령어는 파일 자체를 변경하지 *않고* 대신에 정렬된 결과를 화면으로 보낸다:

```
$ sort -n lengths.txt

  9  methane.pdb
 12  ethane.pdb
 15  propane.pdb
 20  cubane.pdb
 21  pentane.pdb
 30  octane.pdb
107  total
```


`> lengths.txt`을 사용해서 `wc` 실행결과를 `lengths.txt`에 넣었듯이, 
명령문 다음에 `> sorted-lengths.txt`을 넣음으로서, 
임시 파일이름인 `sorted-lengths.txt`에 정렬된 목록 정보를 담을 수 있다. 
이것을 실행한 다음에, 또 다른 `head` 명령어를 실행해서 `sorted-lengths.txt`에서 첫 몇 행을 뽑아낼 수 있다:

```
$ sort -n lengths.txt > sorted-lengths.txt
$ head -n 1 sorted-lengths.txt

  9  methane.pdb
```


`head`에 `-n 1` 매개변수를 사용해서 파일의 첫번째 행만이 필요하다고 지정한다. 
`-n 20`은 처음 20개 행만을 지정한다. 
`sorted-lengths.txt`이 가장 작은 것에서부터 큰 것으로 정렬된 파일 길이 정보를 담고 있어서, 
`head`의 출력 결과는 가장 짧은 행을 가진 파일이 되어야만 된다.


::: {#shell-pipefilter-redirection .rmdcaution}

**동일한 파일에 방향변경하기**

명령어 출력결과를 방향변경하는데 동일한 파일에 보내는 것은 매우 
나쁜 아이디어다. 예를 들어:

```
$ sort -n lengths.txt > lengths.txt
```

위와 같이 작업하게 되면 틀린 결과를 얻을 수 있을 뿐만 아니라
경우에 따라서는 `lengths.txt` 파일 내용을 잃어버릴 수도 있다.

**`>>`은 무엇을 의미하는가?**

`>` 사용법을 살펴봤지만, 유사한 연산자로 `>>`도 있는데 다소 다른 방식으로 동작한다.
문자열을 출력하는 `echo` 명령어를 사용해서, 두 연산자 차이를 밝혀내는데 아래 명령어를 테스트 한다:

```
$ echo hello > testfile01.txt
```

```
$ echo hello >> testfile02.txt
```

힌트: 각 명령문을 연속해서 두번 실행하고 나서, 출력결과로 나온 파일을 면밀히 조사한다.
> **해답**
>
> `>` 연산자를 갖는 첫번째 예제에서 문자열 "hello"는 `testfile01.txt` 파일에 저장된다.
> 하지만, 매번 명령어를 실행할 때마다 파일에 덮어쓰기를 한다.
>
> 두번째 예제에서 `>>` 연산자도 마찬가지로 "hello"를 파일에 저장(이 경우 `testfile02.txt`)하는 것을 알 수 있다.
> We see from the second example that the `>>` operator also writes "hello" to a file
> 하지만, 파일이 이미 존재하는 경우(즉, 두번째 명령어를 실행하게 되면) 파일에 문자열을 덧붙인다.
{: .solution}

:::

::: {#shell-pipefilter-append .rmdcaution}

**데이터 덧붙이기**

`head` 명령어는 이미 만나봤다. 파일 시작하는 몇줄을 화면에 출력하는 역할을 수행한다.
`tail` 명령어도 유사하지만, 반대로 파일 마지막 몇줄을 화면에 출력하는 역할을 수행한다.
`data-shell/data/animals.txt` 파일을 생각해 보자.
다음 명령어를 실행하게 되면 `animalsUpd.txt` 파일에 
저장될 내용이 어떤 것일지 아래에서 정답을 고르세요:

```
$ head -n 3 animals.txt > animalsUpd.txt
$ tail -n 2 animals.txt >> animalsUpd.txt
```

1. `animals.txt` 파일 첫 3줄.
2. `animals.txt` 파일 마지막 2줄.
3. `animals.txt` 파일의 첫 3줄과 마지막 2줄.
4. `animals.txt` 파일의 두번째 세번째 줄.

> **해답**
> 정답은 3. 
> 1번이 정답이 되려면, `head` 명령어만 실행한다.
> 2번이 정답이 되려면, `tail` 명령어만 실행한다.
> 4번이 정답이 되려면, `head -3 animals.txt | tail -2 >> animalsUpd.txt` 명령어를 실행해서 `head` 출력결과를 파이프에 넣어 `tail -2`를 실행해야 한다.
:::


이것이 혼란스럽다면, 좋은 친구네요: 
`wc`, `sort`, `head` 명령어 각각이 무엇을 수행하는지 이해해도, 
중간에 산출되는 파일에 무슨 일이 진행되고 있는지 따라가기는 쉽지 않다. 
`sort`와 `head`을 함께 실행해서 이해하기 훨씬 쉽게 만들 수 있다:

```
$ sort -n lengths.txt | head -n 1

  9  methane.pdb
```

두 명령문 사이의 수직 막대를 **파이프(pipe)**라고 부른다. 
수직막대는 쉘에게 왼편 명령문의 출력결과를 오른쪽 명령문의 입력값으로 사용된다는 뜻을 전달한다. 
컴퓨터는 필요하면 임시 파일을 생성하거나, 
한 프로그램에서 주기억장치의 다른 프로그램으로 데이터를 복사하거나, 
혹은 완전히 다른 작업을 수행할 수도 있다; 
사용자는 알 필요도 없고 관심을 가질 이유도 없다.

어떤 것도 파이프를 연속적으로 사슬로 엮어 사용하는 것을 막을 수는 없다.
즉, 예를 들어 또 다른 파이프를 사용해서 `wc`의 출력결과를 `sort`에 바로 보내고 나서, 
다시 처리 결과를 `head`에 보낸다.
`wc` 출력결과를 `sort`로 보내는데 파이프를 사용했다:

```
$ wc -l *.pdb | sort -n

   9 methane.pdb
  12 ethane.pdb
  15 propane.pdb
  20 cubane.pdb
  21 pentane.pdb
  30 octane.pdb
 107 total
```

또 다른 파이프를 사용해서 `wc`의 출력결과를 `sort`에 바로 보내고 나서, 
다시 처리 결과를 `head`로 보내게 되면 전체 파이프라인은 다음과 같이 된다:

```
$ wc -l *.pdb | sort -n | head -n 1

   9  methane.pdb
```

이것이 정확하게 수학자가 *log(3x)* 같은 중첩함수를 사용하는 것과 같다. 
"*log(3x)*은 x에 3을 곱하고 로그를 취하는 것과 같다." 
이번 경우는, 
`*.pdb`의 행수를 세어서 정렬해서 첫부분만 계산하는 것이 된다.

::: {#shell-pipefilter-connect .rmdcaution}

**명령문을 파이프로 연결하기**

현재 작업 디렉토리에, 최소 행수를 갖는 파일을 세개 찾고자 한다.
아래 열거된 어떤 명령어 중 어떤 것이 원하는 파일 3개를 찾아줄까?

1. `wc -l * > sort -n > head -n 3`
2. `wc -l * | sort -n | head -n 1-3`
3. `wc -l * | head -n 3 | sort -n`
4. `wc -l * | sort -n | head -n 3`

> **해답**
> 해답은 4.
> 파이프 문자 `|`을 사용해서 이 프로세스 표준출력을 다른 프로세스 표준입력으로 넣어준다.
> `>` 기호는 표준입력을 파일로 방향변경할 때 사용한다.
> `data-shell/molecules` 디렉토리에서도 시도해 보라!

:::

파이프를 생성할 때 뒤에서 실질적으로 일어나는 일은 다음과 같다. 
컴퓨터가 한 프로그램(어떤 프로그램도 동일)을 실행할 때 프로그램에 대한 소프트웨어와 현재 상태 정보를 담기 위해서 주기억장치 메모리에 **프로세스(process)**를 생성한다. 
모든 프로세스는 **표준 입력(standard input)**이라는 입력 채널을 가지고 있다. 
(여기서 이름이 너무 기억하기 좋아서 놀랄지도 모른다. 하지만 걱정하지 마세요. 대부분의 유닉스 프로그래머는 "stdin"이라고 부른다). 
또한 모든 프로세스는 **표준 출력(standard output)**(혹은 "stdout")이라고 불리는 기본디폴트 출력 채널도 있다.
이 채널이 일반적으로 오류 혹은 진단 메시지 용도로 사용되어서 
터미널로 오류 메시지를 받으면서도 그 와중에 프로그램 출력값이 또다른 프로그램에 파이프되어 
들어가는 것이 가능하게 한다.


쉘은 실질적으로 또다른 프로그램이다. 
정상적인 상황에서 사용자가 키보드로 무엇을 타이핑하는 모든 것은 표준 입력으로 쉘에 보내지고, 
표준 출력에서 만들어지는 무엇이든지 화면에 출력된다. 
쉘에게 프로그램을 실행하게 할때, 
새로운 프로게스를 생성하고, 임시로 키보드에 타이핑하는 무엇이든지 그 프로세스의 표준 입력으로 보내지고, 
프로세스는 표준 출력을 무엇이든 화면에 전송한다.

`wc -l *.pdb > lengths`을 실행할 때 여기서 일어나는 것을 설명하면 다음과 같다. 
`wc` 프로그램을 실행할 새로운 프로세스를 생성하라고 쉘이 컴퓨터에 지시한다.
파일이름을 인자로 제공했기 때문에 표준입력 대신 `wc`는 인자에서 입력값을 읽어온다. 
`>`을 사용해서 출력값을 파일로 방향변경 했기했기 때문에, 
쉘은 프로세스의 표준 출력결과를 파일에 연결한다.


`wc -l *.pdb | sort -n`을 실행한다면, 쉘은 프로세스 두개를 생성한다. 
(파이프 프로세스 각각에 대해서 하나씩) 그래서 `wc`과 `sort`은 동시에 실행된다. 
`wc`의 표준출력은 직접적으로 `sort`의 표준 입력으로 들어간다; 
`>`같은 방향변경이 없기 때문에 `sort`의 출력은 화면으로 나가게 된다. 
`wc -l *.pdb | sort -n | head -1`을 실행하면, 
파일에서 `wc`에서 `sort`로, `sort`에서 `head`을 통해 화면으로 나가게 되는 데이터 흐름을 가진 프로세스 3개가 있게 된다.


![방향변경과 파이프](assets/images/redirects-and-pipes.png)

이 간단한 아이디어가 왜 유닉스가 그토록 성공적이었는지를 보여준다. 
다른 많은 작업을 수행하는 거대한 프로그램을 생성하는 대신에, 
유닉스 프로그래머는 각자가 한가지 작업만을 잘 수행하는 간단한 도구를 많이 생성하는데 집중하고, 
서로간에 유기적으로 잘 작동하게 만든다. 
이러한 프로그래밍 모델을 파이프와 필터(pipes and filters)라고 부른다; 
파이프는 이미 살펴봤고, **필터(filter)**는 `wc`, `sort`같은 프로그램으로 입력 스트림을 출력 스트림으로 변환하는 것이다. 
거의 모든 표준 유닉스 도구는 이런 방식으로 동작한다: 
별도로 언급되지 않는다면, 
표준 입력에서 읽고, 읽은 것을 가지고 무언가를 수행하고 표준출력에 쓴다.

중요한 점은 표준입력에서 텍스트 행을 읽고, 
표준 출력에 텍스트 행을 쓰는 임의 프로그램은 이런 방식으로 동작하는 모든 다른 프로그램과 조합될 수 있다는 것이다. 
여러분도 여러분이 작성한 프로그램을 이러한 방식으로 작성할 수 있어야 하고 *작성해야 한다*. 
그래서 여러분과 다른 사람들이 이러한 프로그램을 파이프에 넣어서 생태계 전체 힘을 배가할 수 있다.

::: {#shell-pipefilter-direction .rmdcaution}

**입력 방향변경**

프로그램의 출력 결과 방향변경을 위해서 `>`을 사용하는 것과 마찬가지로, `<`을 사용해서 입력을 되돌릴 수도 있다. 
즉, 표준입력 대신에 파일로부터 읽어 들일 수 있다. 
예를 들어, `wc ammonia.pdb` 와 같이 작성하는 대신에, `wc < ammonia.pdb` 작성할 수 있다.
첫째 사례는, `wc`는 무슨 파일을 여는지를 명령 라인의 매개변수에서 얻는다.
두번째 사례는, `wc`에 명령 라인 매개변수가 없다. 
그래서 표준 입력에서 읽지만, 쉘에게 `ammonia.pdb`의 내용을 `wc`에 표준 입력으로 보내라고 했다.

:::

::: {#shell-pipefilter-meaning .rmdcaution}

**`<` 기호이 의미하는 것은 무엇인가?**

(다운로드 예제 데이터를 갖고 있는 최상위) `data-shell` 디렉토리로 작업 디렉토리를 변경한다.
다음 두 명령어 차이는 무엇인가?

```
$ wc -l notes.txt
$ wc -l < notes.txt
```

> **해답**
> `<` 기호는 입력을 방향변경을 해서 명령어로 전달한다.
>
> 상기 예제 모두에서, 쉘은 입력에서 `wc` 명령어를 통해 행수를 반환한다.
> 첫번째 예제에서, 입력은 `notes.txt` 파일이고, 파일명이 
> `wc` 명령어로부터 출력으로 주어지게 된다.
> 두번째 예제로부터, `notes.txt` 파일 내용이 표준입력으로 방향변경을 통해 보내지게 된다.
> 이것은 마치 프롬프트에서 파일 콘텐츠를 타이핑하는 것과 같다.
> 따라서, 파일명이 출력에 주어지지 않는다 - 단지 행번호만 주어진다.
> 다음과 같이 타이핑해보자:
>
> ```
> $ wc -l
> this
> is
> a test
> Ctrl-D # Ctrl-D를 타이핑하게 되면 쉘이 입력을 마무리한 것을 알게 전달하는 역할을 한다.
>
>
> ```
> 3
> ```

:::


::: {#shell-pipefilter-unique .rmdcaution}

**`uniq`가 왜 인접한 중복 행만을 단지 제거한다고 생각합니까?**

명령문 `uniq`는 입력으로부터 인접한 중복된 행을 제거한다. 
예를 들어, `salmon.txt` 파일에 다음이 포함되었다면,

```
coho
coho
steelhead
coho
steelhead
steelhead
```

`data-shell/data` 디렉토리의 `uniq salmon.txt` 명령문 실행은 다음을 출력한다. 

```
coho
steelhead
coho
steelhead
```

`uniq`가 왜 인접한 중복 행만을 단지 제거한다고 생각합니까? 
(힌트: 매우 큰 파일을 생각해보세요.) 
모든 중복된 행을 제거하기 위해, 파이프로 다른 어떤 명령어를 조합할 수 있을까요?
> **해답**
>
> ```
> $ sort salmon.txt | uniq
> ```

:::

::: {#shell-pipefilter-comprehension .rmdcaution}


**파이프 독해능력**

`data-shell/data` 폴더에 `animals.txt`로 불리는 파일은 다음 데이터를 포함한다

```
2012-11-05,deer
2012-11-05,rabbit
2012-11-05,raccoon
2012-11-06,rabbit
2012-11-06,deer
2012-11-06,fox
2012-11-07,rabbit
2012-11-07,bear
```

다음 아래 파이프라인에 각 파이프를 통과하고, 마지막 방향변경을 마친 텍스트는 무엇이 될까요?

```
$ cat animals.txt | head -n 5 | tail -n 3 | sort -r > final.txt
```

힌트: 명령어를 한번에 하나씩 작성해서 파이프라인을 구축한 뒤에 이해한 것이 맞는지 시험한다.

> **해답**
> `head` 명령어는 `animals.txt` 파일에서 첫 5 행을 추출한다.
> 그리고 나서, `tail` 명령어로 이전 5 행에서 마지막 3 행을 추출된다.
> `sort -r` 명령어는 역순으로 정렬을 시키게 된다.
> 마지막으로 출력결과는 `final.txt` 파일에 방향변경하여 화면이 아닌 파일로 보내진다.
> 파일에 저장된 내용은 `cat final.txt` 명령어를 실행하면 확인이 가능하다.
> 파일에는 다음 내용이 저장되어야 한다:
> ```
> 2012-11-06,rabbit
> 2012-11-06,deer
> 2012-11-05,raccoon
> ```

:::

::: {#shell-pipefilter-construction .rmdcaution}

**파이프 구성하기**

이전 연습문제에 사용된 `animals.txt` 파일을 가지고 다음 명령어를 실행한다:

```
$ cut -d , -f 2 animals.txt
```


콤마를 구분자로 각 행을 쪼개려고 하면 `-d` 플래그를 사용하고,
`-f` 플래그는 각행의 두번째 필드를 지정하게 되서 출력결과는 다음과 같다:

```
deer
rabbit
raccoon
rabbit
deer
fox
rabbit
bear
```

파일에 담겨 있는 동물이 무엇인지를 알아내려면, 
다른 어떤 명령어가 파이프라인에 추가되어야 하나요? 
(동물 이름에 어떠한 중복도 없어야 합니다.)

> **해답**
> ```
> $ cut -d , -f 2 animals.txt | sort | uniq
> ```
> {: .language-bash}

:::


::: {#shell-pipefilter-selection .rmdcaution}

**파이프 선택?**

`animals.txt` 파일은 아래 형식으로 586줄로 구성되어 있다:

```
2012-11-05,deer
2012-11-05,rabbit
2012-11-05,raccoon
2012-11-06,rabbit
...
```

`data-shell/data/` 현재 디렉토리로 가정하고,
다음 중 어떤 명령어가 동물 종류별로 전체 출현 빈도수를 나타내는 표를 
작성하는데 사용하면 좋을까요?

1.  `grep {deer, rabbit, raccoon, deer, fox, bear} animals.txt | wc -l`
2.  `sort animals.txt | uniq -c`
3.  `sort -t, -k2,2 animals.txt | uniq -c`
4.  `cut -d, -f 2 animals.txt | uniq -c`
5.  `cut -d, -f 2 animals.txt | sort | uniq -c`
6.  `cut -d, -f 2 animals.txt | sort | uniq -c | wc -l`

> **해답**
> 정답은 5.
> 정답을 이해하는데 어려움이 있으면, (`data-shell/data` 디렉토리에 위치한 것을 확인한 후)
> 명령어 전체를 실행하거나, 파이프라인 일부를 실행해 본다.

:::

## Nelle 파이프라인: 파일 확인하기 {#nelle-file}

앞에서 설명한 것처럼 Nelle은 분석기를 통해 시료를 시험해서 17개 파일을 `north-pacific-gyre/2012-07-03` 디렉토리에 생성했다. 
빠르게 건전성 확인하기 위해, 홈디렉토리에서 시작해서, 다음과 같이 타이핑한다:

```
$ cd north-pacific-gyre/2012-07-03
$ wc -l *.txt
```



결과는 다음과 같은 18 행이 출력된다:

```
300 NENE01729A.txt
300 NENE01729B.txt
300 NENE01736A.txt
300 NENE01751A.txt
300 NENE01751B.txt
300 NENE01812A.txt
... ...
```

이번에는 다음과 같이 타이핑한다:

```
$ wc -l *.txt | sort -n | head -n 5

 240 NENE02018B.txt
 300 NENE01729A.txt
 300 NENE01729B.txt
 300 NENE01736A.txt
 300 NENE01751A.txt
```


이런, 파일중에 하나가 다른 것보다 60행이 짧다. 
다시 돌아가서 확인하면, 월요일 아침 8:00 시각에 분석을 수행한 것을 알고 있다 --- 
아마도 누군가 주말에 기계를 사용했고, 다시 재설정하는 것을 깜빡 잊었을 것이다. 
시료를 다시 시험하기 전에 파일중에 너무 큰 데이터가 있는지를 확인한다:

```
$ wc -l *.txt | sort -n | tail -n 5

 300 NENE02040B.txt
 300 NENE02040Z.txt
 300 NENE02043A.txt
 300 NENE02043B.txt
5040 total
```

숫자는 예뻐 보인다 --- 
하지만 끝에서 세번째 줄에 'Z'는 무엇일까? 
모든 시료는 'A' 혹은 'B'로 표시되어야 한다. 
시험실 관례로 'Z'는 결측치가 있는 시료를 표식하기 위해 사용된다. 
더 많은 결측 시료를 찾기 위해, 다음과 같이 타이핑한다:

```
$ ls *Z.txt

NENE01971Z.txt    NENE02040Z.txt
```

노트북의 로그 이력을 확인할 때, 상기 샘플 각각에 대해 깊이(depth) 정보에 대해서 기록된 것이 없었다. 
다른 방법으로 정보를 더 수집하기에는 너무 늦어서, 
분석에서 두 파일을 제외하기로 했다. 
`rm` 명령어를 사용하여 삭제할 수 있지만, 
향후에 깊이(depth)정보가 관련없는 다른 분석을 실시할 수도 있다. 
그래서 와일드 카드 표현식 `*[AB].txt`을 사용하여 파일을 조심해서 선택하기로 한다. 
언제나 그렇듯이, '\*'는 임의 숫자의 문자를 매칭한다. 
`[AB]` 표현식은 'A'혹은 'B'를 매칭해서 Nelle이 가지고 있는 유효한 데이터 파일 모두를 매칭한다.

::: {#shell-pipefilter-expression .rmdcaution}

**와일드카드 표현식(Wildcard Expressions)**

와일드카드 표현식은 매우 복잡할 수 있지만, 종종 다소 장황할 수 있는 비용을 지불하고 
간단한 구문만 사용해서 작성하기도 한다.
`data-shell/north-pacific-gyre/2012-07-03` 디렉토리를 생각해 보자:
`*[AB].txt` 와일드카드 표현식은 `A.txt` 혹은 `B.txt`으로 끝나는 모든 파일을 매칭시킨다.
이 와일드카드 표현식을 잊었다고 상상해보자:

1.  `[]` 구문을 사용하지 않는 기본 와일드드카드 표현식으로 동일하게 파일을 매칭할 수 있을까?
  *힌트*: 표현식이 하나 이상 필요할 수도 있다.
2.  `[]` 구문을 사용하지 않고 작성한 표현식은 동일한 파일을 매칭한다.
    두 출력결과의 작은 차이점은 무엇인가?
3.  최초 와일드카드 표현식은 오류가 나지 않는데 어떤 상황에서 본인 표현식은 오류 메시지를 출력하는가?

> **해답**
> 1. 
>
> ```
> 	$ ls *A.txt
> 	$ ls *B.txt
> ```
>	
> 2. 새로운 명령어에서 나온 출력결과는 명령어가 두개라 구분된다.
The output from the new commands is separated because there are two commands.
> 3. `A.txt`로 끝나는 파일이 없거나 `B.txt`로 끝나는 파일이 없는 경우 그렇다.

:::

::: {#shell-pipefilter-remove .rmdcaution}

**불필요한 파일 제거하기**

저장공간을 절약하고자 중간 처리된 데이터 파일을 삭제하고 
원본 파일과 처리 스크립트만 보관했으면 한다고 가정하자.

원본 파일은 `.dat`으로 끝나고, 처리된 파일은 `.txt`으로 끝난다.
다음 중 어떤 명령어가 처리과정에서 생긴 중간 모든 파일을 삭제하게 하는가?
1. `rm ?.txt`
2. `rm *.txt`
3. `rm * .txt`
4. `rm *.*`

> **해답**
> 1. 한문자 `.txt` 파일을 제거한다.
> 2. 정답
> 3. `*` 기호로 인해 현재 디렉토리 모든 파일과 디렉토리를 매칭시킨다.
> 그래서 `*` 기호로 매칭되는 모든 것과 추가로 `.txt` 파일도 삭제한다.
> 4. `*.*` 기호는 임의 확장자를 갖는 모든 파일을 매칭시킨다.
> 따라서 `*.*` 기호는 모든 파일을 삭제한다.



:::
