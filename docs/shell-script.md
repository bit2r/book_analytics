

# 쉘 스크립트 {#shell-script}


마침내 쉘을 그토록 강력한 프로그래밍 환경으로 탈바꾼할 준비가 되었다. 
자주 반복적으로 사용되는 명령어들을 파일에 저장시키고 나서, 
단 하나의 명령어를 타이핑함으써 나중에 이 모든 연산 작업작업을 다시 재실행할 수 있다. 
역사적 이유로 파일에 저장된 명령어 꾸러미를 통상 **쉘 스크립트(shell script)**라고 부르지만,
실수로 그렇게 부르는 것은 아니다: 실제로 작은 프로그램이다.

`molecules/` 디렉토리로 돌아가서 `middle.sh` 파일에 다음 행을 추가하게 되면 쉘스크립트가 된다:

```
$ cd molecules
$ nano middle.sh
```

`nano middle.sh` 명령어는 `middle.sh` 파일을 텍스트 편집기 "nano"로 열게 한다.
(편집기 프로그램은 쉘 내부에서 실행된다.)
`middle.sh` 파일이 존재하지 않는 경우, `middle.sh` 파일을 생성시킨다.
텍스트 편집기를 사용해서 직접 파일을 편집한다 -- 단순히 다음 행을 삽입시킨다:

```
head -n 15 octane.pdb | tail -n 5
```

앞서 작성한 파이프에 변형이다: `octane.pdb` 파일에서 11-15 행을 선택한다. 
기억할 것은 명령어로서 실행하지 *않고*: 명령어를 파일에 적어 넣는다는 것이다.

그리고 나서 나노 편집기에서 `Ctrl-O`를 눌러 파일을 저장하고,
나노 편집기에서 `Ctrl-X`를 눌러 텍스트 편집기를 빠져나온다.
`molecules` 디렉토리에 `middle.sh` 파일이 포함되어 있는지 확인한다.


Once we have saved the file,
we can ask the shell to execute the commands it contains.
Our shell is called `bash`, so we run the following command:

파일을 저장하면, 쉘로 하여금 파일에 담긴 명령어를 실행하도록 한다.
지금 쉘은 `bash`라서, 다음과 같이 다음 명령어를 실행시킨다:

```
$ bash middle.sh

ATOM      9  H           1      -4.502   0.681   0.785  1.00  0.00
ATOM     10  H           1      -5.254  -0.243  -0.537  1.00  0.00
ATOM     11  H           1      -4.357   1.252  -0.895  1.00  0.00
ATOM     12  H           1      -3.009  -0.741  -1.467  1.00  0.00
ATOM     13  H           1      -3.172  -1.337   0.206  1.00  0.00
```

아니나 다를까, 스크립트의 출력은 정확하게 파이프라인을 직접적으로 실행한 것과 동일하다.

::: {#shell-script-text .rmdcaution}

**텍스트 vs. 텍스트가 아닌 것 아무거나**

종종 마이크로소프트 워드 혹은 리브르오피스 Writer 프로그램을 "텍스트 편집기"라고 부른다.
하지만, 프로그래밍을 할때 조금더 주의를 기울일 필요가 있다. 
기본 디폴트로, 마이크로소프트 워드는 `.docx` 파일을 사용해서 텍스트를 저장할 뿐만 아니라,
글꼴, 제목, 등등의 서식 정보도 함께 저장한다. 
이런 추가 정보는 문자로 저장되지 않아서, `head` 같은 도구에게는 무의미하다: 
`head` 같은 도구는 입력 파일에 문자, 숫자, 표준 컴퓨터 키보드 특수문자만이 포함되어 있는 것을 예상한다.
따라서, 프로그램을 편집할 때, 일반 텍스트 편집기를 사용하거나, 
혹은 일반 텍스트로 파일을 저장하도록 주의한다.

:::

만약 임의 파일의 행을 선택하고자 한다면 어떨까요? 
파일명을 바꾸기 위해서 매번 `middle.sh`을 편집할 수 있지만, 
단순히 명령어를 다시 타이핑하는 것보다 아마 시간이 더 걸릴 것이다. 
대신에 `middle.sh`을 편집해서 좀더 다양한 기능을 제공하도록 만들어보자:

```
$ nano middle.sh
```

나노 편집기로 `octane.pdb`을 `$1`으로 불리는 특수 변수로 변경하자:

```
head -n 15 "$1" | tail -n 5
```

쉘 스크립트 내부에서, `$1`은 "명령라인의 첫 파일 이름(혹은 다른 인자)"을 의미한다. 
이제 스크립트를 다음과 같이 바꿔 실행해 보자:

```
$ bash middle.sh octane.pdb

ATOM      9  H           1      -4.502   0.681   0.785  1.00  0.00
ATOM     10  H           1      -5.254  -0.243  -0.537  1.00  0.00
ATOM     11  H           1      -4.357   1.252  -0.895  1.00  0.00
ATOM     12  H           1      -3.009  -0.741  -1.467  1.00  0.00
ATOM     13  H           1      -3.172  -1.337   0.206  1.00  0.00
```


혹은 다음과 같이 다른 파일에 대해 스크립트 프로그램을 실행해 보자:

```
$ bash middle.sh pentane.pdb

ATOM      9  H           1       1.324   0.350  -1.332  1.00  0.00
ATOM     10  H           1       1.271   1.378   0.122  1.00  0.00
ATOM     11  H           1      -0.074  -0.384   1.288  1.00  0.00
ATOM     12  H           1      -0.048  -1.362  -0.205  1.00  0.00
ATOM     13  H           1      -1.183   0.500  -1.412  1.00  0.00
```


::: {#shell-script-argument .rmdcaution}

**인자 주위를 이중 인용부호로 감싸기**

파일명에 공백이 포함된 경우 루프 변수 내부에 이중 인용부호로 감싼 것과 동일한 사유로,
파일명에 공백이 포함된 경우 이중 인용부호로 `$1`을 감싼다.
:::

하지만, 매번 줄 범위를 조정할 때마다 여전히 `middle.sh` 파일을 편집할 필요가 있다.
이 문제를 특수 변수 `$2` 와 `$3` 을 사용해서 고쳐보자: `head`, `tail` 명령어에 
해당 줄수를 출력하도록 인자로 넘긴다.

```
$ nano middle.sh
```

```
head -n "$2" "$1" | tail -n "$3"
```


이제 다음을 실행시킨다:

```
$ bash middle.sh pentane.pdb 15 5

ATOM      9  H           1       1.324   0.350  -1.332  1.00  0.00
ATOM     10  H           1       1.271   1.378   0.122  1.00  0.00
ATOM     11  H           1      -0.074  -0.384   1.288  1.00  0.00
ATOM     12  H           1      -0.048  -1.362  -0.205  1.00  0.00
ATOM     13  H           1      -1.183   0.500  -1.412  1.00  0.00
```

명령문의 인자를 변경함으로써 스크립트 동작을 바꿀 수 있게 된다:

```
$ bash middle.sh pentane.pdb 20 5

ATOM     14  H           1      -1.259   1.420   0.112  1.00  0.00
ATOM     15  H           1      -2.608  -0.407   1.130  1.00  0.00
ATOM     16  H           1      -2.540  -1.303  -0.404  1.00  0.00
ATOM     17  H           1      -3.393   0.254  -0.321  1.00  0.00
TER      18              1
```

제대로 동작하지만, 
`middle.sh` 쉘스크립트를 읽는 다른 사람은 잠시 시간을 들여, 
스크립트가 무엇을 수행하는지 알아내야 할지 모른다. 
스크립트를 상단에 **주석(comments)**을 추가해서 좀더 낫게 만들 수 있다:

```
$ nano middle.sh
```

```
# Select lines from the middle of a file.
# Usage: bash middle.sh filename end_line num_lines
head -n "$2" "$1" | tail -n "$3"
```


주석은 `#`문자로 시작하고 해당 행 끝까지 주석으로 처리된다. 
컴퓨터는 주석을 무시하지만, 
사람들이(미래의 본인 자신도 포함) 스크립트를 이해하고 사용하는데 정말 귀중한 존재다.
유일한 단점은 스크립트를 변경할 때마다, 주석이 여전히 유효한지 확인해야 된다는 점이다:
잘못된 방향으로 독자를 오도하게 만드는 설명은 아무것도 없는 것보다 더 나쁘다.

만약 많은 파일을 단 하나 파이프라인으로 처리하고자 한다면 어떨까? 
예를 들어, `.pdb` 파일을 길이 순으로 정렬하려면, 다음과 같이 타이핑한다:

```
$ wc -l *.pdb | sort -n
```

`wc -l`은 파일에 행갯수를 출력하고(wc는 'word count'로 -l 플래그를 추가하면 'count lines'의미가 됨을 상기한다), 
`sort -n`은 숫자순으로 파일의 행갯수를 정렬한다. 
파일에 담을 수 있지만, 현재 디렉토리에 `.pdb` 파일만을 정렬한다. 
다른 유형의 파일에 대한 정렬된 목록을 얻으려고 한다면, 
스크립트에 이 모든 파일명을 얻는 방법이 필요하다. 
`$1`, `$2` 등등은 사용할 수 없는데, 
이유는 얼마나 많은 파일이 있는지를 예단할 수 없기 때문이다. 
대신에, 특수 변수 `$@`을 사용한다. 
`$@`은 "쉘 스크립트 모든 명령-라인 인자"를 의미한다. 
공백을 포함한 매개변수를 처리하려면 이중 인용부호로 `$@`을 감싸두어야 된다.
(`"$@"`은  `"$1"` `"$2"` ... 와 동치다).
예제가 다음에 있다:

```
$ nano sorted.sh
```

```
# Sort filenames by their length.
# Usage: bash sorted.sh one_or_more_filenames
wc -l "$@" | sort -n
```

실행방법과 실행결과는 다음과 같다.

```
$ bash sorted.sh *.pdb ../creatures/*.dat

9 methane.pdb
12 ethane.pdb
15 propane.pdb
20 cubane.pdb
21 pentane.pdb
30 octane.pdb
163 ../creatures/basilisk.dat
163 ../creatures/unicorn.dat
```

::: {#shell-script-unique .rmdcaution}

유일무이한 개체 목록으로 나열
정훈이는 데이터 파일 수백개를 갖고 있는데, 각각은 다음과 같은 형식을 가지고 있다:

```
2013-11-05,deer,5
2013-11-05,rabbit,22
2013-11-05,raccoon,7
2013-11-06,rabbit,19
2013-11-06,deer,2
2013-11-06,fox,1
2013-11-07,rabbit,18
2013-11-07,bear,1
```

`data-shell/data/animal-counts/animals.txt` 파일을 대상으로 예제를 작성한다.
임의 파일이름을 명령-라인 인자로 갖는 `species.sh` 이름의 쉘 스크립트를 작성하라. 
`cut`, `sort`, `uniq`를 사용해서 각각의 파일별로 나오는 유일무이한 개체에 대한 목록을 화면에 출력하세요.

> **해답**
>
> ```
> # csv 파일에 유일무이한 개체를 찾는 스크립트로 개체는 두번째 데이터 필드가 된다.
> # 스크립트는 명령라인 인자로 모든 파일명을 인자로 받는다.
>
> # 모든 파일에 대해 루프를 돌려 반복한다.
> ```
> for file in $@ 
> do
> 	echo "Unique species in $file:"
> 	# 개체명을 추출한다.
> 	cut -d , -f 2 $file | sort | uniq
> done
> ```

:::

::: {#shell-script-nothing .rmdcaution}

**왜 쉘 스크립트가 어떤 작업도 수행하지 않을까?**

스크립트가 아주 많은 파일을 처리하고 했지만, 어떠한 파일 이름도 부여하지 않는다면 무슨 일이 발생할까? 
예를 들어, 만약 다음과 같이 타이핑한다면 어떻게 될까요?:

```
$ bash sorted.sh
```

하지만 `*.dat` (혹은 다른 어떤 것)를 타이핑하지 않는다면 어떨까요? 
이 경우 `$@`은 아무 것도 전개하지 않아서, 스크립트 내부의 파이프라인은 사실상 다음과 같다:

```
$ wc -l | sort -n
```

어떠한 파일이름도 주지 않아서, `wc`은 표준 입력을 처리하려 한다고 가정한다.
그래서, 단지 앉아서 사용자가 인터랙티브하게 어떤 데이터를 전달해주길 대기하고만 있게 된다.
하지만, 밖에서 보면 사용자에게 보이는 것은 스크립트가 거기 앉아서 정지한 것처럼 보인다:
스크립트가 아무 일도 수행하지 않는 것처럼 보인다.

:::

유용한 무언가를 수행하는 일련의 명령어를 방금 실행했다고 가정하자 --- 
예를 들어, 논문에 사용될 그래프를 스크립트가 생성. 
필요하면 나중에 그래프를 다시 생성할 필요가 있어서, 
파일에 명령어를 저장하고자 한다. 
명령문을 다시 타이핑(그리고 잠재적으로 잘못 타이핑할 수도 있다)하는 대신에, 다음과 같이 할 수도 있다:

```
$ history | tail -n 5 > redo-figure-3.sh
```


`redo-figure-3.sh` 파일은 이제 다음을 담고 있다:

```
297 bash goostats NENE01729B.txt stats-NENE01729B.txt
298 bash goodiff stats-NENE01729B.txt /data/validated/01729.txt > 01729-differences.txt
299 cut -d ',' -f 2-3 01729-differences.txt > 01729-time-series.txt
300 ygraph --format scatter --color bw --borders none 01729-time-series.txt figure-3.png
301 history | tail -n 5 > redo-figure-3.sh
```

명령어의 일련 번호를 제거하고, `history` 명령어를 포함한 마지막 행을 지우는 작업을
편집기에서 한동안 작업한 후에,
그림을 어떻게 생성시켰는지에 관한 정말 정확한 기록을 갖게 되었다.

::: {#shell-script-record .rmdcaution}

**왜 명령어를 실행하기 전에 `history`에 명령어를 기록할까?**

다음 명령어를 실행시키게 되면:

```
$ history | tail -n 5 > recent.sh
```

파일에 마지막 명령어는 `history` 명령 그자체다; 즉
쉘이 실제로 명령어를 실행하기 전에 명령 로그에 먼저 `history`를 추가했다.
실제로 *항상* 쉘은 명령어를 실행시키기 전에 로그에 명령어를 기록한다.
왜 이런 동작을 쉘이 한다고 생각하는가?

> **해답**
> 만약 명령어가 죽던가 멈추게 되면, 어떤 명령어에서 
> 문제가 발생했는지 파악하는 것이 유용할 수 있다.
> 명령어가 실행된 후에 기록하게 되면,
> 크래쉬(crash)가 발생된 마지막 명령어에 대한 기록이 없게 된다.

:::

실무에서, 대부분의 사람들은 쉘 프롬프트에서 몇번 명령어를 실행해서 올바르게 수행되는지를 확인한 다음, 
재사용을 위해 파일에 저장한다. 
이런 유형의 작업은 데이터와 작업흐름(workflow)에서 발견한 것을 
`history`를 호출해서 재사용할 수 있게 하고, 
출력을 깔끔하게 하기 위해 약간의 편집을 하고 나서, 
쉘 스크립트로 저장하는 흐름을 탄다.


## Nelle 파이프라인: 스크립트 생성하기 {#nelle-script}

Nelle의 지도교수는 모든 분석결과가 재현가능해야 된다는 고집을 갖고 있다.
모든 분석 단계를 담아내는 가장 쉬운 방법은 스크립트에 있다.
편집기를 열어서 다음과 같이 작성한다:

```
# 데이터 파일별로 통계량 계산.
for datafile in "$@"
do
    echo $datafile
    bash goostats $datafile stats-$datafile
done
```

`do-stats.sh` 이름으로된 파일에 저장해서, 
다음과 같이 타이핑해서 첫번째 단계 분석을 다시 실행할 수 있게 되었다:

```
$ bash do-stats.sh NENE*[AB].txt
```


또한 다음과 같이도 할 수 있다:

```
$ bash do-stats.sh NENE*[AB].txt | wc -l
```

그렇게 해서 출력은 처리된 파일 이름이 아니라 처리된 파일의 숫자만 출력된다.

Nelle의 스크립트에서 주목할 한가지는 스크립트를 실행하는 사람이 무슨 파일을 처리할지를 결정하게 하는 것이다. 
스크립트를 다음과 같이 작성할 수 있다:

```
# Site A, Site B 데이터 파일에 대한 통계량 계산
for datafile in NENE*[AB].txt
do
    echo $datafile
    bash goostats $datafile stats-$datafile
done
```

장점은 이 스크립트는 항상 올바른 파일만을 선택한다: 'Z'파일을 제거했는지 기억할 필요가 없다. 
단점은 *항상* 이 파일만을 선택한다는 것이다 --- 
모든 파일('Z'를 포함하는 파일), 혹은 남극 동료가 생성한 'G', 'H' 파일에 대해서 스크립트를 편집하지 않고는 실행할 수 없다. 
좀더 모험적이라면, 스크립트를 변경해서 명령-라인 매개변수를 검증해서 만약 어떠한 매개변수도 제공되지 않았다면 `NENE*[AB].txt`을 사용하도록
바꿀수도 있다.
물론, 이런 접근법은 유연성과 복잡성 사이에 서로 대립되는 요소 사이의 균형, 즉 트레이드오프(trade-off)를 야기한다.

::: {#shell-script-variable .rmdcaution}

**쉘 스크립트의 변수**

`molecules` 디렉토리에서, 다음 명령어를 포함하는 `script.sh`라는 쉘스크립트가 있다고 가정한다:

```
head -n $2 $1
tail -n $3 $1
```

`molecules` 디렉토리에서 다음 명령어를 타이핑한다:

```
bash script.sh '*.pdb' 1 1
```

다음 출력물 결과 중 어떤 결과가 나올 것으로 예상하나요?
1. `molecules` 디렉토리에 있는 `*.pdb` 확장자를 갖는 각 파일의 첫번줄과 마지막줄 사이 모든 줄을 출력.
2. `molecules` 디렉토리에 있는 `*.pdb` 확장자를 갖는 각 파일의 첫번줄과 마지막 줄을 출력.
3. `molecules` 디렉토리에 있는 각 파일의 첫번째와 마지막 줄을 출력.
4. `*.pdb` 를 감싸는 인용부호로 오류가 발생.

> **해답**
> 정답은 2. 
>
> 특수 변수 $1, $2, $3은 스크립트에 명령라인 인수를 나타낸다. 따라서 
> 실행되는 명령어는 다음과 같다:
>
> ```
> $ head -n 1 cubane.pdb ethane.pdb octane.pdb pentane.pdb propane.pdb
> $ tail -n 1 cubane.pdb ethane.pdb octane.pdb pentane.pdb propane.pdb
> ```
> 
> 인용부호로 감싸져서 쉘이 `'*.pdb'`을 명령라인에서 확장하지 않는다.
> 이를 테면, 스크립트의 첫번째 인자는 `'*.pdb'`으로 전달되어 스크립트 내부에서 확장되어 
> `head`와 `tail` 명령어를 실행시키게 된다.

:::

::: {#shell-script-long-file .rmdcaution}

주어진 확장자 내에서 가장 긴 파일을 찾아낸다
인자로 디렉토리 이름과 파일이름 확장자를 갖는 `longest.sh`이름의 쉘 스크립트를 작성해서,
그 디렉토리에서 해당 확장자를 가지는 파일 중에 가장 긴 줄을 가진 파일이름을 화면에 출력하세요. 
예를 들어, 다음은

```
$ bash longest.sh /tmp/data pdb
```

`/tmp/data` 디렉토리에 `.pdb` 확장자를 가진 파일 중에 가장 긴 줄을 가진 파일이름을 화면에 출력한다.

> **해답**
>
> ```
> # 쉘 스크립트는 다음 두 인자를 갖는다: 
> #    1. 디렉토리명
> #    2. 파일 확장자
> # 해당 디렉토리에서 파일 확장자와 매칭되는 가장 길이가 긴 파일명을 출력한다.
> 
> wc -l $1/*.$2 | sort -n | tail -n 2 | head -n 1
> ```

:::

::: {#shell-script-reading .rmdcaution}

**스크립트 독해 능력**

이번 문제에 대해, 다시 한번  `data-shell/molecules` 디렉토리에 있다고 가정한다.
지금까지 생성한 파일에 추가해서 디렉토리에는 `.pdb` 파일이 많다. 
만약 다음 행을 담고 있는 스크립트로 `bash example.sh *.dat`을 실행할 때, 
`example.sh` 이름의 스크립트가 무엇을 수행하는지 설명하세요:

```
# 스크립트 1
echo *.*
```

```
# 스크립트 2
for filename in $1 $2 $3
do
    cat $filename
done
```

```
# 스크립트 3
echo $@.pdb
```

> **해답**
> 스크립트 1은 파일명에 구두점(`.`)이 포함된 모든 파일을 출력한다.
>
> 스크립트 2는 파일 확장자가 매칭되는 첫 3 파일의 내용을 화면에 출력시킨다.
> 쉘이 인자를 `example.sh` 스크립트에 전달하기 전에 와일드카드를 확장시킨다.
> 
> 스크립트 3은 `.pdb`로 끝나는 스크립트의 모든 인자(즉, 모든 `.pdb` 파일)를 화면에 출력시킨다.
> 
> ```
> cubane.pdb ethane.pdb methane.pdb octane.pdb pentane.pdb propane.pdb.pdb
> ```

:::


::: {#shell-script-debugging .rmdcaution}

**스크립트 디버깅**

Nelle 컴퓨터 `north-pacific-gyre/2012-07-03` 디렉토리의 
`do-errors.sh` 파일에 다음과 같은 스크립트가 저장되었다고 가정하자. 

```
# Calculate stats for data files.
for datafile in "$@"
do
    echo $datfile
    bash goostats $datafile stats-$datafile
done
```

다음을 실행하게 되면:

```
$ bash do-errors.sh NENE*[AB].txt
```

출력결과는 아무 것도 없다.
원인을 파악하고자 `-x` 선택옵션을 사용해서 스크립트를 재실행시킨다:

```
bash -x do-errors.sh NENE*[AB].txt
```

보여지는 출력결과는 무엇인가?
몇번째 행에서 오류가 발생했는가?
> **해답**
> `-x` 플래그를 사용하면 디버그 모드에서 `bash`를 실행시키게 된다.
> 각 명령어를 행단위로 실행시키고 출력결과를 보여주는데, 오류를 특정하는데 도움이 된다.
> 이번 예제에서 `echo` 명령어는 아무 것도 출력하지 않는 것을 볼 수 있다.
> 루프 변수명의 철자가 잘못 타이핑 되어 있다.
> `datfile` 변수가 존재하지 않아서 빈 문자열이 반환되었다.

:::
