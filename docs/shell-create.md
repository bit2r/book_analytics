
# 파일과 디렉토리 작업 {#shell-create}

이제는 어떻게 파일과 디렉토리를 살펴보는지 알게 되었지만, 
우선, 어떻게 파일과 디렉토리를 생성할 수 있을까요? 
바탕화면(Desktop) `data-shell` 디렉토리로 돌아가서 
`ls -F` 명령어를 사용하여 무엇을 담고 있는지 살펴봅시다:

```
$ pwd
/Users/nelle/Desktop/data-shell
```


```
$ ls -F
creatures/  data/  molecules/  north-pacific-gyre/  notes.txt  pizza.cfg  solar.pdf  writing/
```

명령어 `mkdir thesis`을 사용하여 새 디렉토리 `thesis`를 생성합시다
(출력되는 것은 아무것도 없습니다.):


```
$ mkdir thesis
```

이름에서 유추를 할 수도, 하지 못할 수도 있지만, 
`mkdir`은 "make directory(디렉토리 생성하기)"를 의미한다. 
`thesis`는 상대 경로여서(즉, 앞에 슬래쉬가 없음), 
새로운 디렉토리는 현재 작업 디렉토리 아래 만들어진다:

```
$ ls -F
creatures/  data/  molecules/  north-pacific-gyre/  notes.txt  pizza.cfg  solar.pdf  thesis/  writing/
```

::: {#shell-create-two .rmdcaution}
**동일한 작업을 수행하는 두가지 방법**

쉘을 사용해서 디렉토리를 생성하는 것이나 파일 탐색기를 사용하는 것과 별반 차이가 없다.
운영체제 그래픽 파일 탐색기를 사용해서 현재 디렉토리를 열게 되면,
`thesis` 디렉토리가 마찬가지로 나타난다.
파일과 상호작용하는 두가지 다른 방식이 존재하지만,
파일과 디렉토리는 동일하다.
:::

::: {#shell-create-naming .rmdcaution}

## 파일과 디렉토리를 위한 좋은 명칭

명령라인으로 작업할 때, 복잡하고 어려운 파일과 디렉토리는 삶을 질을 현격히 저하시킨다.
다음에 파일 명칭에 대한 유용한 팁이 몇개 있다.

1. 공백(whitespaces)을 사용하지 마라
   공백은 이름을 의미있게 할 수도 있지만,
   공백이 명령라인 인터페이스에서 인자를 구별하는데 사용되기에,
   파일과 디렉토리 명에서는 피하는 것이 상책이다.
   공백 대신에 `-` 혹은 `_` 문자를 사용한다.
   
2. 대쉬(`-`)로 명칭을 시작하지 않는다.
   명령어가 `-`으로 시작되는 명칭을 선택옵션으로 처리하기 때문이다.
   
3. 명칭에 문자, 숫자, `.` (마침표), `-` (대쉬) and `_` (밑줄)을 고수한다.
   명령라인 인터페이스에서 다른 많은 문자는 특별한 의미를 갖는다.
   학습을 진행하면서 이들 중 일부를 배울 것이다.
   일부 특수 문자는 명령어가 기대했던 대로 동작하지 못하게 하거나,
   심한 경우 데이터 유실을 야기할 수도 있다.
   
   
공백을 포함하거나 알파벳이 아닌 문자를 갖는 파일명이나 디렉토리명을 굳이 지정할 필요가 있다면,
인용부호(`""`)로 파일명이나 디렉토리명을 감싸야 한다.
:::

`thesis` 디렉토리를 방금 생성했기에 내부에는 아무것도 없다:

```
$ ls -F thesis
```

`cd` 명령어를 사용하여 `thesis`로 작업 디렉토리를 변경하자. 
Nano 텍스트 편집기를 실행해서 `draft.txt` 파일을 생성하자:

```
$ cd thesis
$ nano draft.txt
```

::: {#shell-create-editor .rmdcaution}

**어떤 편집기가 좋을까요?**

"`nano`가 텍스트 편집기다"라고 말할 때, 정말 "텍스트"만 의미한다. 
즉, 일반 문자 데이터만 작업할 수 있고, 표, 이미지, 혹은 다른 형태의 인간 친화적 미디어는 작업할 수 없다. 
`nano`를 워크샵에서 사용하는데 이유는 거의 누구나 훈련없이 사용할 수 있기 때문이다. 
하지만, 실제 작업에는 좀더 강력한 편집기 사용을 추천한다. 
유닉스 시스템 계열(맥 OS X, 리눅스)에서 많은 프로그래머는 
[Emacs](http://www.gnu.org/software/emacs/) 혹은 [Vim](http://www.vim.org/)을 사용하거나, 
(둘다 완전히 비직관적이만, 심지어 유닉스 표준이기도 하다)
혹은 그래픽 편집기로 [Gedit](http://projects.gnome.org/gedit/)를 사용한다. 
윈도우에서는 [Notepad++](http://notepad-plus-plus.org/)를 사용하는 것도 좋다.
윈도우에는 `메모장(notepad)`이라고 불리는 자체 내장 편집기도 있는데 
`nano` 편집기와 마찬가지로 명령라인에서 바로 불러 실행될 수 있다.

어떤 편집기를 사용하든, 파일을 검색하고 저장하는 것을 알 필요가 있다. 
쉘에서 편집기를 시작하면, (아마도) 현재 작업 디렉토리가 디폴트 시작 위치가 된다. 
컴퓨터 시작 메뉴에서 시작한다면, 대신에 바탕화면(Desktop) 혹은 문서 디렉토리에 파일을 저장하고 싶을지도 모른다. 
"다른 이름으로 저장하기(Save As ...)"로 다른 디렉토리로 이동하여 작업 디렉토리를 변경하여 파일을 저장할 수도 있다.
:::

텍스트 몇 줄을 타이핑하고, 
컨트롤+O (Control-O, Ctrl 혹은 콘트롤 키보드를 누르면서 `O` 를 누름)를 눌러서 데이터를 디스크에 쓰면 저장된다:
(저장하고자 하는 파일명을 입력하도록 독촉받게 되면 `draft.txt` 기본디폴트로 설정된 것을 받아들이고 엔터키를 친다.)


![Nano in Action](assets/images/nano-screenshot.png)


파일이 저장되면, 컨트롤+X (`Ctrl-X`, Control-X)를 사용하여 편집기를 끝내고 쉘로 돌아간다. 

::: {#shell-create-control .rmdcaution}

**Control, Ctrl, ^ Key**

컨트롤 키를 줄여서 "Ctrl" 키라고도 부른다.
컨트롤 키를 기술하는 몇가지 방식이 있다.
예를 들어, "컨트롤 키를 누룬다", "컨트롤 키를 누르면서 X 키를 친다"라는 표현은 
다음 중 하나로 기술된다:

* `Control-X`
* `Control+X`
* `Ctrl-X`
* `Ctrl+X`
* `^X`
* `C-x`

`nano` 편집기에서 화면 하단에 `^G Get Help ^O WriteOut`을 볼 수 있다.
`Control-G`를 눌러 도움말을 얻고, `Control-O`를 눌러 파일을 저장한다는 의미를 갖는다.

:::


`nano`는 화면에 어떤 출력도 뿌려주지 않고 끝내지만, 
`ls` 명령어를 사용하여 `draft.txt` 파일이 생성된 것을 확인할 수 있다:

```
$ ls
draft.txt
```

::: {#shell-create-alternative .rmdcaution}

**파일을 생성하는 다른 방법**

`nano` 편집기를 사용해서 텍스트 파일을 생성하는 방법을 살펴봤다.
홈 디렉토리에서 다음 명령어를 실행해 보자:

```
$ cd                  # 홈 디렉토리로 이동하기
$ touch my_file.txt
```

1.  `touch` 명령어는 어떤 작업을 수행하는가?
    GUI 파일 탐색기를 사용해서 본인 홈 디렉토리를 살펴보게 되면,
    파일이 생성된 것이 보이는가?
2. `ls -l` 명령어를 사용해서 파일을 살펴보자. `my_file.txt` 파일은 얼마나 큰가?
3.  이런 방식으로 파일을 언제 생성하면 좋을까?

> **실행결과 및 해석**
>
> 1.  `touch` 명령어가 홈 디렉토리에 'my_file.txt' 파일을 새로 생성시킨다.
>     터미널로 현재 홈 디렉토리에 있는 경우, `ls` 를 타이핑하게 되면 
>     새로 생성된 파일을 확인할 수 있다. GUI 파일 탐색기로도 
>     'my_file.txt' 파일을 볼 수 있다.
>
> 2.  'ls -l' 명령어로 파일을 조사하게 되면, 'my_file.txt' 파일크기가 0kb 임에 주목한다.
>     다른 말로 표현하면, 데이터가 아무 것도 없다는 의미가 된다.
>     텍스트 편집기로 'my_file.txt' 파일을 열게 되면, 텅 비어 있다.
>
> 3.  일부 프로그램은 그 자체로 출력 파일을 생성하지 않지만,
>     빈 파일이 이미 생성되어 있는 것을 요구조건으로 하는 경우가 있다.
>     프로그램이 실행되면, 출력결과를 채울 수 있는 파일이 존재하는지 검색한다.
>     이런 프로그램에게 `touch` 명령어는 빈 텍스트 파일을 효율적으로 생성할 수 있는 
>     메커니즘을 제공한다는 점에서 유용하다.

:::

`data-shell` 디렉토리로 돌아가서,
생성한 초안을 제거해서 `thesis` 디렉토리를 깔끔하게 정리하자:

```
$ cd thesis
$ rm draft.txt
```

상기 명령어는 파일을 제거한다(`rm`은 "remove"를 줄인 것이다.)
`ls` 명령어를 다시 실행하게 되면,
출력결과는 아무 것도 없게 되는데 파일이 사라진 것을 확인시켜준다:

```
$ ls
```

::: {#shell-create-delete .rmdcaution}

**삭제는 영원하다**

유닉스에는 삭제된 파일을 복구할 수 있는 휴지통이 없다. 
(하지만, 유닉스에 기반한 대부분의 그래픽 인터페이스는 휴지통 기능이 있다)
파일을 삭제하면 파일시스템의 관리대상에서 빠져서 디스트 저장공간이 다시 재사용되게 한다. 
삭제된 파일을 찾아 되살리는 도구가 존재하지만, 
어느 상황에서나 동작한다는 보장은 없다. 
왜냐하면 파일이 저장되었던 공간을 컴퓨터가 바로 재사용할지 모르기 때문이다.
:::

파일을 다시 생성하고 나서, `cd ..`를 사용하여 `/Users/nelle/Desktop/data-shell` 상위 디렉토리로 이동해보자:

```
$ pwd
/Users/nelle/Desktop/data-shell/thesis
```

```
$ nano draft.txt
$ ls
draft.txt
```

```
$ cd ..
```

`rm thesis`을 사용하여 전체 `thesis` 디렉토리를 제거하려고 하면 오류 메시지가 생긴다:

```
$ rm thesis
rm: cannot remove `thesis': Is a directory
```


`rm` 명령어는 파일에만 동작하고 디렉토리에는 동작하지 않기 때문에 오류가 발생한다. 
`thesis` 디렉토리를 제거하려면, `draft.txt` 파일도 삭제해야 한다.
`rm` 명령어에 [재귀(recursive)](https://en.wikipedia.org/wiki/Recursion) 선택옵션을 사용해서 
삭제 작업을 수행할 수 있다:

```
$ rm -r thesis
```

::: {#shell-create-safely .rmdcaution}

**`rm` 안전하게 사용하기**

`rm -i thesis/quotations.txt` 타이핑하면 무슨 일이 일어날까?
`rm` 명령어를 사용할 때 왜 이러한 보호장치가 필요할까?

>
> ```
> $ rm: remove regular file 'thesis/quotations.txt'?
> ```
> 
> `-i` 선택옵션은 삭제하기 전에 삭제를 확인하게 해준다.
> 유닉스 쉘에는 휴지통이 없어서, 삭제되는 모든 파일은 영원히 사라진다.
> `-i` 플래그를 사용하게 되면, 삭제를 원하는 파일만 삭제되는지 점검할 수 있는 기회를 갖게된다.

:::



::: {#shell-create-great .rmdcaution}

**큰 힘에는 큰 책임이 따른다(With Great Power Comes Great Responsibility)**

디렉토리에 먼저 파일을 제거하고, 그리고 나서 디렉토리를 제거하는 방식은 지루하고 시간이 많이 걸린다. 
대신에 `-r` 옵션을 가진 `rm` 명령어를 사용할 수 있다. 
`-r` 플래그 옵션은 "recursive(재귀적)"을 나타낸다.

```
$ rm -r thesis
```

디렉토리에 모든 것을 삭제하고 나서 디렉토리 자체도 삭제한다. 
만약 디렉토리가 하위 디렉토리를 가지고 있다면, `rm -r`은 하위 디렉토리에도 같은 작업을 반복한다. 
매우 편리하지만, 부주위하게 사용되면 피해가 엄청날 수 있다.

디렉톨리 파일을 재귀적으로 제거하는 것은 매우 위험할 수 있다.
삭제되는 것에 염려가 된다면, `rm` 명령어에 `-i` 인터랙티브 플래그를 추가해서
삭제단계마다 확인을 하고 삭제하는 것도 가능하다.

```
$ rm -r -i thesis
rm: descend into directory ‘thesis’? y
rm: remove regular file ‘thesis/draft.txt’? y
rm: remove directory ‘thesis’? y
```


상기 명령어는 `thesis` 디렉토리 내부 모든 것을 삭제하고 나서 `thesis` 디렉토리도 
삭제하는데 삭제단계별로 확인 절차를 거친다.
:::


다시 한번 디렉토리와 파일을 생성하자. 
이번에는 `thesis/draft.txt` 파일경로로 바로 `nano`를 실행함을 주목하자. 
이전에는 `thesis`디렉토리로 가서 `draft.txt`이름으로 `nano`를 실행했다.

```
$ pwd
/Users/nelle/Desktop/data-shell
```

```
$ mkdir thesis
$ nano thesis/draft.txt
$ ls thesis
draft.txt
```

## 파일과 폴더 이동 {#shell-move-file}


`draft.txt`가 특별한 정보를 제공하는 이름이 아니어서 `mv`를 사용하여 파일 이름을 변경하자. 
`mv`는 "move"의 줄임말이다:

```
$ mv thesis/draft.txt thesis/quotes.txt
```


첫번째 매개변수는 `mv` 명령어에게 이동하려는 대상을, 두번째 매개변수는 어디로 이동되는지를 나타낸다. 
이번 경우에는 `thesis/draft.txt` 파일을 `thesis/quotes.txt`으로 이동한다. 
이렇게 파일을 이동하는 것이 파일 이름을 바꾸는 것과 동일한 효과를 가진다. 
아니나 다를까, `ls` 명령어를 사용하여 확인하면 `thesis` 디렉토리에는 이제 `quotes.txt` 파일만 있음을 확인할 수 있다:

```
$ ls thesis
quotes.txt
```


목표 파일명을 명세할 때 주의를 기울일 필요가 있다. 
왜냐하면, `mv` 명령어는 동일 명칭을 갖는
어떤 기존 파일도 아주 조용히 덮어 써버리는 재주가 있어 데이터 유실에 이르게 된다.
부가적인 옵션 플래그, `mv -i` (즉 `mv --interactive`)를 사용해서
덮어쓰기 전에 사용자가 확인하도록 `mv` 명령어를 활용할 수도 있다.

일관성을 갖고 있어서, `mv`는 디렉토리에도 동작한다 --- 별도 `mvdir` 명령어는 없다.

`quotes.txt` 파일을 현재 작업 디렉토리로 이동합시다. 
`mv`를 다시 사용한다. 
하지만 이번에는 두번째 매개변수로 디렉토리 이름을 사용해서 파일이름을 바꾸지 않고, 새로운 장소에 놓는다. 
(이것이 왜 명령어가 "move(이동)"으로 불리는 이유다.) 
이번 경우에 사용되는 디렉토리 이름은 앞에서 언급한 특수 디렉토리 이름 `.` 이다.

```
$ mv thesis/quotes.txt .
```

과거에 있던 디렉토리에서 파일을 현재 작업 디렉토리로 옮긴 효과가 나타난다.
`ls` 명령어가 `thesis` 디렉토리가 비였음을 보여준다:

```
$ ls thesis
```


더 나아가, 
`ls` 명령어를 인자로 파일 이름 혹은 디렉토리 이름과 함께 사용하면, 
그 해당 파일 혹은 디렉토리만 화면에 보여준다. 
이렇게 사용하면, `quotes.txt` 파일이 현재 작업 디렉토리에 있음을 볼 수 있다:


```
$ ls quotes.txt
quotes.txt
```

::: {#shell-create-move .rmdcaution}

**현재 폴더로 이동하기**

다음 명령어를 실행한 후에, 정훈이는 `sucrose.dat`, `maltose.dat` 파일을 잘못된 폴더에 넣은 것을 인지하게 되었다:

```
$ ls -F
 analyzed/ raw/
$ ls -F analyzed
fructose.dat glucose.dat maltose.dat sucrose.dat
$ cd raw/
```

해당 파일을 현재 디렉토리(즉, 현재 사용자가 위치한 폴더)로 이동시키도록 아래 빈칸을 채우시오:

```
$ mv ___/sucrose.dat  ___/maltose.dat ___
```

> 
> ```
> $ mv ../analyzed/sucrose.dat ../analyzed/maltose.dat .
> ```
> 
> `..` 디렉토리는 부모 디렉토리(즉, 현재 디렉토리에서 상위 디렉토리를 지칭)
> `.` 디렉토리는 현재 디렉토리를 지칭함을 상기한다.

:::


`cp` 명령어는 `mv` 명령어와 거의 동일하게 동작한다. 
차이점은 이동하는 대신에 복사한다는 점이다. 
인자로 경로를 두개 갖는 `ls` 명령어로 제대로 작업을 했는지 확인할 수 있다.
대부분의 유닉스 명령어와 마찬가지로, `ls` 명령어로 한번 경로 다수를 전달할 수도 있다:


```
$ cp quotes.txt thesis/quotations.txt
$ ls quotes.txt thesis/quotations.txt
quotes.txt   thesis/quotations.txt
```

복사를 제대로 수행했는지 증명하기 위해서, 
현재 작업 디렉토리에 있는 `quotes.txt` 파일을 삭제하고 나서, 다시 동일한 `ls` 명령어를 실행한다. 

```
$ rm quotes.txt
$ ls quotes.txt thesis/quotations.txt
ls: cannot access quotes.txt: No such file or directory
thesis/quotations.txt
```


이번에는 현재 디렉토리에서 `quotes.txt` 파일은 찾을 수 없지만, 
삭제하지 않은 thesis 폴더의 복사본은 찾아서 보여준다.

::: {#shell-create-important .rmdcaution}

**파일명이 뭐가 중요해?**

Nelle의 파일 이름이 "무엇.무엇"으로 된 것을 알아챘을 것이다. 
이번 학습에서, 항상 `.txt` 확장자를 사용했다.
이것은 단지 관례다: 파일 이름을 `mythesis` 혹은 원하는 무엇이든지 작명할 수 있다. 
하지만, 대부분의 사람들은 두 부분으로 구분된 이름을 사용하여
사람이나 프로그램이 다른 유형의 파일임을 구분하도록 돕는다. 
이름에 나온 두번째 부분을 **파일 확장자(filename extension)**라고 부르고, 
파일에 어떤 유형의 데이터가 담고 있는지 나타낸다. 
`.txt` 확장자는 텍스트 파일임을, `.pdf`는 PDF 문서임을, 
`.cfg` 확장자는 어떤 프로그램에 대한 구성정보를 담고 있는 형상관리 파일임을 내고,
`.png` 확장자는 PNG 이미지 등등을 나타낸다.

단지 관습이기는 하지만 중요하다. 
파일은 바이트(byte) 정보를 담고 있다: PDF 문서, 이미지, 등에 대해서 규칙에 따라 
바이트를 해석하는 것은 사람과 작성된 프로그램에 맡겨졌다.

`whale.mp3`처럼 고래 PNG 이미지 이름을 갖는 파일을 고래 노래의 음성파일로 변환하는 마술은 없다. 
설사 누군가 두번 클릭할 때, 운영체제가 음악 재생기로 열어 실행할 수는 있지만 동작은 되지 않을 것이다.

:::

::: {#shell-create-rename .rmdcaution}

**파일 이름 바꾸기**

데이터를 분석하는데 필요한 통계 검정 목록을 담고 있는 `.txt` 파일을 현재 디렉토리에 생성했다고 가정하자;
파일명은 `statstics.txt`.
파일을 생성하고 저장한 후에 곰곰히 생각해 보니 파일명 철자가 틀린 것을 알게 되었다!
틀린 철자를 바로잡고자 하는데, 다음 중 어떤 명령어를 사용해야 하는가?
1. `cp statstics.txt statistics.txt`
2. `mv statstics.txt statistics.txt`
3. `mv statstics.txt .`
4. `cp statstics.txt .`

> **해답**
> 1. No. 철자오류가 수정된 파일이 생성되지만, 철자가 틀린 파일도 디렉토리에 여전히 존재하기 때문에 삭제작업이 필요하다.
> 2. Yes, 이 명령어를 통해서 파일명을 고칠 수 있다.
> 3. No, 마침표(.)는 파일을 이동할 디렉토리를 나타내지 새로운 파일명을 제시하고 있지는 않고 있다; 동일한 파일명은 생성될 수 없다.
> 4. No, 마침표(.)는 파일을 복사할 디렉토리를 나타내지 새로운 파일명을 제시하고 있지는 않고 있다; 동일한 파일명은 생성될 수 없다.

:::

::: {#shell-create-move-copy .rmdcaution}

**이동과 복사**
아래 보여진 일련의 명령문에 뒤에 `ls`명령어의 출력값은 무엇일까요?

```
$ pwd
/Users/jamie/data
```

```
$ ls
proteins.dat
```

```
$ mkdir recombine
$ mv proteins.dat recombine/
$ cp recombine/proteins.dat ../proteins-saved.dat
$ ls
```

1.   `proteins-saved.dat recombine`
2.   `recombine`
3.   `proteins.dat recombine`
4.   `proteins-saved.dat`

> **해답**
> `/Users/jamie/data` 디렉토리에서 출발해서, `recombine` 이름의 디렉토리를 새로 생성한다.
> 두번째 행은 `proteins.dat` 파일을 새로 만든 폴더 `recombine`으로 이동(`mv`) 시킨다.
> 세번째 행은 방금전에 이동한 파일에 대한 사본을 생성시킨다.
> 여기서 조금 까다로운 점은 파일이 복사되는 디렉토리다.
> `..` 이 의미하는 바가 "한단계 위로 이동"하라는 의미라서,
> 복사되는 파일은 이제 `/Users/jamie` 디렉토리에 위치하게 됨을 상기한다.
> `..` 이 의미하는 바는 복사되는 파일 위치에 대한 것이 **아니라** 현재 작업 디렉토리에 대한 
>  것으로 해석됨에 유의한다. 
>  그래서, 그래서, `ls` 명령어를 사용해서 보여지게 되는 것은 (`/Users/jamie/data`에 있기 때문에) `recombine` 폴더가 된다.
>
> 1. No, 상기 해설을 참조한다. `proteins-saved.dat` 데이터는 `/Users/jamie` 폴더에 위치한다.
> 2. Yes
> 3. No, 상기 해설을 참조한다.  `proteins.dat` 데이터는 `/Users/jamie/data/recombine` 폴더에 위치한다.
> 4. No, 상기 해설을 참조한다.  `proteins-saved.dat` 데이터는 `/Users/jamie` 폴더에 위치한다.

:::

## 다수 파일과 폴더 작업 {#shell-moving-multiple}

::: {#shell-create-copy-files .rmdcaution}

**다수 파일을 복사하기**
이번 연습문제에서는 `data-shell/data` 디렉토리에서 명령어를 테스트한다.
아래 예제에서, 파일명 다수와 디렉토리명이 주어졌을 떄 `cp` 명령어는 어떤 작업을 수행하는가?

```
$ mkdir backup
$ cp amino-acids.txt animals.txt backup/
```

아래 예제에서, 3개 혹은 그 이상의 파일명이 주어졌을 때 `cp` 명령어는 어떤 작업을 수행하는가?

```
$ ls -F
amino-acids.txt  animals.txt  backup/  elements/  morse.txt  pdb/  planets.txt  salmon.txt  sunspot.txt
```

```
$ cp amino-acids.txt animals.txt morse.txt 
```

> **해답**
> 하나이상 파일명 다음에 디렉토리명이 주어지게 되면(즉, 목적지 디렉토리는 마지막 인자에 위치해야 한다.), 
> `cp` 명령어는 파일을 해당 디렉토리에 복사한다.
>
> 연달아 파일명이 세게 주어지면, `cp` 명령어는 오류를 던지는데 이유는 마지막 인자로 디렉토리를 기대했기 때문이다.
>
> ```
> cp: target ‘morse.txt’ is not a directory
> ```

:::

::: {#shell-create-wildcards .rmdcaution}

**와일드 카드(Wildcards)**


`*`는 **와일드카드(wildcard)**다. 
와일드카드는 0 혹은 그 이상의 문자와 매칭되서, 
`*.pdb`은 `ethane.pdb`, `propane.pdb` 등등에 매칭한다.
반면에,  `p*.pdb`은 `propane.pdb`와 `pentane.pdb`만 매칭하는데, 
맨 앞에 'p'로 시작되는 파일명만 일치하기만 하면 되기 때문이다.

`?`도 또한 와일드카드지만 단지 단일 문자만 매칭한다. 
이것이 의미하는 바는 `p?.pdb`은 `pi.pdb`  
혹은 `p5.pdb`을 매칭하지만 (`molecules` 디렉토리에 두 파일이 있다면), 
`propane.pdb`은 매칭하지 않는다. 
한번에 원하는 수만큼 와일드카드를 사용할 수 있다. 
예를 들어, `p*.p?*`는 'p'로 시작하고 '.'과 'p', 
그리고 최소 한자의 이상의 문자로 끝나는 임의의 문자열을 매칭한다고 표현할 수 있는데 
'?'이 한 문자를 매칭해야하고 마지막 '\*'은 끝에 임의의 문자숫자와 매칭할 수 있기 때문이다. 
그래서 `p*.p?*`은 `preferred.practice`과 심지어 `p.pi`도 매칭한다(첫번째 '\*'은 어떤 문자도 매칭할 수가 없음). 
하지만 `quality.practice`은 매칭할 수 없는데 이유는 'p'로 시작하지 않고, 
`preferred.p`도 매칭할 수 없는데 'p' 다음에 최소 하나의 문자가 필요한데 없기 때문이다.

쉘이 와일드카드를 봤을 때, 요청된 명령문을 시작하기 *전에* 와일드카드를 확장하여 매칭할 파일 이름 목록을 생성한다. 
예외로, 와일드카드 표현식이 어떤 파일과도 매칭되지 않게되면, 배수는 명령어에 인자로 표현식을 있는 그대로 전달한다.
예를 들어, `molecules` 디렉토리(`.pdb` 확장자로 끝나는 파일만 모여있다.)에 `ls *.pdf`을 타이핑하게 되면, `*.pdf`으로 불리는 파일이 없다고 
오류 메시지를 출력한다.
하지만, 일반적으로 `wc`과 `ls` 명령어는 와일드카드 표현식과 매칭되는 파일명 목록을 보게 되고 와일드카드 
자체가 아니다.
다른 프로그램은 아니지만, 쉘은 와일드카드를 확장한 것을 다룬다는 점에서 
직교 설계(orthogonal design)의 또 다른 사례로 볼 수 있다.

:::

::: {#shell-create-wildcards-plus .rmdcaution}

**와일드카드 추가 문제** 

정훈이는 미세조정(calibration), 원본 데이터(dataset), 데이터 설명 데이터를 디렉토리에 보관하고 있다:

```
2015-10-23-calibration.txt
2015-10-23-dataset1.txt
2015-10-23-dataset2.txt
2015-10-23-dataset_overview.txt
2015-10-26-calibration.txt
2015-10-26-dataset1.txt
2015-10-26-dataset2.txt
2015-10-26-dataset_overview.txt
2015-11-23-calibration.txt
2015-11-23-dataset1.txt
2015-11-23-dataset2.txt
2015-11-23-dataset_overview.txt
```

또 다른 견학여행을 떠나기 전에, 정훈이는 데이터를 백업하고 
일부 데이터를 랩실 동료 기민에게 보내고자 한다.
정훈이는 백업과 전송 작업을 위해서 다음 명령어를 사용한다:

```
$ cp *dataset* /backup/datasets
$ cp ____calibration____ /backup/calibration
$ cp 2015-____-____ ~/send_to_bob/all_november_files/
$ cp ____ ~/send_to_bob/all_datasets_created_on_a_23rd/
```

정훈이가 빈칸을 채우도록 도움을 주세요.
> **해답**
> 
> ```
> $ cp *calibration.txt /backup/calibration
> $ cp 2015-11-* ~/send_to_bob/all_november_files/
> $ cp *-23-dataset* ~send_to_bob/all_datasets_created_on_a_23rd/
> ```

:::

::: {#shell-create-directory .rmdcaution}

**디렉토리와 파일 조직화**

정훈이가 프로젝트 작업을 하고 있는데, 작업 파일이 그다지 잘 조직적으로 정리되어 있지 않음을 알게 되었다:

```
$ ls -F
analyzed/  fructose.dat    raw/   sucrose.dat
```

`fructose.dat` 와 `sucrose.dat` 파일은 자료분석 결과 산출된 출력결과를 담고 있다.
이번 학습에서 배운 어떤 명령어를 실행해야,
아래 명령어를 실행했을 때 다음에 보여지는 출력을 생성할까요?

```
$ ls -F
analyzed/   raw/
```

```
$ ls analyzed
fructose.dat    sucrose.dat
```

> **해답**
> 
> ```
> mv *.dat analyzed
> ```
> 
> 정훈이는 `analyzed` 디렉토리에 `fructose.dat`, `sucrose.dat` 파일을 이동시킬 필요가 있다.
> 쉘에서  현재 디렉토리에서 `*.dat` 와일드카드가 `.dat` 확장자를 갖는 모든 파일을 매칭한다.
> `mv` 명령어가 `.dat` 확장자를 갖는 파일을 `analyzed` 디렉토리로 이동시킨다.

:::

::: {#shell-create-not-file .rmdcaution}

**폴더 구조를 복사하지만, 파일을 복사하지 말자.**

새로운 실험을 시작해 보자. 데이터 파일 없이 이전 실험에게 만들었던 
파일 구조만 복제하자. 그렇게 하면 새로운 데이터를 쉽게 추가할 수 있게 된다.
'2016-05-18-data' 디렉토리에 `data` 폴더로 `raw`와 `processed`가 있는데,
각자 데이터 파일이 담겨있다.

목적은 `2016-05-18-data` 폴더를 `2016-05-20-data` 폴더로 복사하는 것인데 
복사된 폴더에는 모든 데이터 파일을 제거해야 된다.
다음 명령어 집합 중 어떤 명령어 집합이 상기 목적을 달성할까요?
다른 명령어 집합은 무슨 작업을 수행하는 것일가?

```
$ cp -r 2016-05-18-data/ 2016-05-20-data/
$ rm 2016-05-20-data/raw/*
$ rm 2016-05-20-data/processed/*
```

```
$ rm 2016-05-20-data/raw/*
$ rm 2016-05-20-data/processed/*
$ cp -r 2016-05-18-data/ 2016-5-20-data/
```

```
$ cp -r 2016-05-18-data/ 2016-05-20-data/
$ rm -r -i 2016-05-20-data/
```

>
> **해답**
>
> 첫번째 명령어들이 해당 목적을 달성한다.
> 먼저 재귀적으로 데이터 폴더를 복사한다.
> 그리고 나서 `rm` 명령어 두번 사용해서 복사한 디렉토리의 모든 파일을 제거한다.
> 쉘은 `*` 와일드카드로 매칭되는 모든 파일과 하위디렉토리를 확장하도록 한다.
>
> 두번째 명령어들은 순서가 잘못되었다:
> 복사하지 않는 파일을 샂게하고 나서 재귀 복사 명령어로 디렉토리를 복사했다.
>
> 세번째 명령어도 목적을 달성하는데, 시간이 다소 소요된다:
> 첫번째 명령어가 디렉토리를 재귀적으로 복사하지만, 두번째 명령어는 인터랙티브하게 
> 각 파일과 디렉토리에 대한 확인하는 과정을 거쳐 
> 삭제를 하게 되어 시간이 추가로 소요된다.

:::



