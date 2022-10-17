---
output: html_document
editor_options: 
  chunk_output_type: console
---




# 결측 데이터 (Missing Data) {#database-null}


현실 세계 데이터는 결코 완전하지 않고 구멍은 항상 있다.
`null`로 불리는 특별한 값을 사용하여 데이터베이스는 구멍을 표현한다.
`null`는 0, `False`, 혹은 빈 문자열도 아니다."아무것도 없음(nothing here)"을 의미하는 특별한 값이다.
`null`을 다루는 것은 약간 특별한 기교와 신중한 생각을 요구한다.

시작으로 `Visited` 테이블을 살펴보자. 레코드가 8개 있지만 #752은 날짜가 없다. 혹은 더 정확히 말하면 날짜가 `null`이다.

```
$ sqlite3 survey.db
SQLite version 3.35.4 2021-04-02 15:20:15
Enter ".help" for usage hints.
sqlite>
```



```sql
select * from Visited;
```


\begin{table}

\caption{(\#tab:sqlite-null-sql)결측값을 갖는 테이블}
\centering
\begin{tabular}[t]{r|l|l}
\hline
ident & site & dated\\
\hline
619 & DR-1 & 1927-02-08\\
\hline
622 & DR-1 & 1927-02-10\\
\hline
734 & DR-3 & 1939-01-07\\
\hline
735 & DR-3 & 1930-01-12\\
\hline
751 & DR-3 & 1930-02-26\\
\hline
752 & DR-3 & NA\\
\hline
837 & MSK-4 & 1932-01-14\\
\hline
844 & DR-1 & 1932-03-22\\
\hline
\end{tabular}
\end{table}


`Null` 다른 값과는 다르게 동작한다.
만약 1930년 이전 레코드를 선택한다면, 



```sql
select * from Visited where dated<'1930-00-00';
```


\begin{table}

\caption{(\#tab:sqlite-null-where)1930년 이전 레코드 선택}
\centering
\begin{tabular}[t]{r|l|l}
\hline
ident & site & dated\\
\hline
619 & DR-1 & 1927-02-08\\
\hline
622 & DR-1 & 1927-02-10\\
\hline
\end{tabular}
\end{table}


결과 2개를 얻게 되고, 만약 1930년 동안 혹은 이후 레코드를 선택한다면,


```sql
select * from Visited where dated>='1930-00-00';
```


\begin{table}

\caption{(\#tab:sqlite-null-where-after)1930년 이후 레코드 선택}
\centering
\begin{tabular}[t]{r|l|l}
\hline
ident & site & dated\\
\hline
734 & DR-3 & 1939-01-07\\
\hline
735 & DR-3 & 1930-01-12\\
\hline
751 & DR-3 & 1930-02-26\\
\hline
837 & MSK-4 & 1932-01-14\\
\hline
844 & DR-1 & 1932-03-22\\
\hline
\end{tabular}
\end{table}


결과를 5개 얻게되지만, 레코드 #752은 결과값 어디에도 존재하지 않는다.
이유는 `null<'1930-00-00'` 평가결과가 참도 거짓도 아니기 때문이다.
`null` 이 의미하는 것은 "알수가 없다"는 것이다.
그리고 만약 비교 평가식의 왼쪽편 값을 알지 못한다면, 비교도 참인지 거짓인지 알수가 없다.
데이터베이스는 "알 수 없음"을 `null`로 표현하기 때문에, `null<'1930-00-00'`의 값도 사실 `null`이다.
`null>='1930-00-00'`도 또한 `null`인데 왜냐하면 질문에 답을 할 수 없기 때문이다.
그리고, `where`절에 레코드는 테스트가 참인 것만 있기 때문에 레코드 #752은 어느 결과값에도 포함되지 않게 된다.

평가식만 `null`값을 이와 같은 방식으로 다루는 연산자는 아니다. 
`1+null`도 `null`이고,
`5*null`도 `null`이고,
`log(null)`도 `null`이 된다.
특히, 무언가를 = 과 != 으로 `null`과 비교하는 것도 `null`이 된다.


```sql
select * from Visited where dated=NULL;
```


\begin{table}

\caption{(\#tab:sqlite-null-filter)NULL 값 갖는 레코드 선택}
\centering
\begin{tabular}[t]{r|l|l}
\hline
ident & site & dated\\


\hline
\end{tabular}
\end{table}



```sql
select * from Visited where dated!=NULL;
```


\begin{table}

\caption{(\#tab:sqlite-not-null-filter)NULL 값 갖지 않는 레코드 선택}
\centering
\begin{tabular}[t]{r|l|l}
\hline
ident & site & dated\\


\hline
\end{tabular}
\end{table}


`null` 인지 아닌지를 점검하기 위해서, 특별한 테스트 `is null`을 사용해야 한다.



```sql
select * from Visited where dated is NULL;
```


\begin{table}

\caption{(\#tab:sqlite-is-null-filter)`is NULL` 사용 NULL 값 갖는 레코드 선택}
\centering
\begin{tabular}[t]{r|l|l}
\hline
ident & site & dated\\
\hline
752 & DR-3 & NA\\
\hline
\end{tabular}
\end{table}


혹은, 역으로는 `is not null`을 사용한다.



```sql
select * from Visited where dated is not NULL;
```


\begin{table}

\caption{(\#tab:sqlite-is-not-null-filter)`is not NULL` 사용 NULL 값 갖지 않는 레코드 선택}
\centering
\begin{tabular}[t]{r|l|l}
\hline
ident & site & dated\\
\hline
619 & DR-1 & 1927-02-08\\
\hline
622 & DR-1 & 1927-02-10\\
\hline
734 & DR-3 & 1939-01-07\\
\hline
735 & DR-3 & 1930-01-12\\
\hline
751 & DR-3 & 1930-02-26\\
\hline
837 & MSK-4 & 1932-01-14\\
\hline
844 & DR-1 & 1932-03-22\\
\hline
\end{tabular}
\end{table}


`null` 값은 나타나는 곳마다 두통을 일으킨다.
예를 들어, Dyer가 측정하지 않은 모든 염분 정보를 찾는다고 가정하자.
다음과 같이 쿼리를 작성하는 것은 당연하다.


```sql
select * from Survey where quant='sal' and person!='lake';
```


\begin{table}

\caption{(\#tab:sqlite-null-filter-headache)NULL 값이 갖는 문제}
\centering
\begin{tabular}[t]{r|l|l|r}
\hline
taken & person & quant & reading\\
\hline
619 & dyer & sal & 0.13\\
\hline
622 & dyer & sal & 0.09\\
\hline
752 & roe & sal & 41.60\\
\hline
837 & roe & sal & 22.50\\
\hline
\end{tabular}
\end{table}

하지만, 상기 쿼리 필터는 누가 측정을 했는지 모르는 레코드는 빠뜨린다.
다시 한번, 이유는 `person`이 `null`일 때, `!=`비교는 `null`값을 만들어서
레코드가 결과값에 있지 않게 된다. 만약 이런 레코드도 유지하려고 한다면, 
명시적으로 검사를 추가할 필요가 있다.



```sql
select * from Survey where quant='sal' and (person!='lake' or person is null);
```


\begin{table}

\caption{(\#tab:sqlite-null-filter-solution)NULL 값 갖는 문제 명시적 해결}
\centering
\begin{tabular}[t]{r|l|l|r}
\hline
taken & person & quant & reading\\
\hline
619 & dyer & sal & 0.13\\
\hline
622 & dyer & sal & 0.09\\
\hline
735 & NA & sal & 0.06\\
\hline
752 & roe & sal & 41.60\\
\hline
837 & roe & sal & 22.50\\
\hline
\end{tabular}
\end{table}


여전히 이러한 접근법이 맞는 것인지 아닌 것인지 판단할 필요가 있다.
만약 절대적으로 결과에 Lake가 측정한 어떠한 값도 포함하지 않는다고 확신한다면,
누가 작업을 한 것인지 모르는 모든 레코드를 제외할 필요가 있다.


## 도전 과제 {#db-null-challenge}

1.  날짜가 알려지지 않은 (즉 `null`) 항목은 빼고, 날짜 순으로 `Visited` 테이블에 있는 레코드를 정렬한 쿼리를 작성하세요.

1.  다음 쿼리가 무슨 결과를 할까요?

    ```
    select * from Visited where dated in ('1927-02-08', null);
    ```

    상기 쿼리가 실질적으로 무엇을 생기게 할까요?

1.  몇몇 데이터베이스 디자이너는 `null` 보다 결측 데이터를 표기하기 위해서 **보초값(sentinel value)**를 사용한다.
    예를 들어, 결측 날짜를 표기하기 위해서 "0000-00-00" 날짜를 사용하거나 결측 염분치 혹은 결측 방사선 측정값을 표기하기 위해서 -1.0을 사용한다.
    (왜냐하면 실제 측정값이 음수가 될 수 없기 때문이다.)
    이러한 접근법은 무엇을 단순화할까요? 이러한 접근법이 어떤 부담과 위험을 가져올까요?


## 주요점 {#db-null-points}

*   데이터베이스는 결측 정보를 표현하기 위해서 `null`을 사용한다.
*   `null`이 관계되는 산술 혹은 불 연산 결과도 `null`이다.
*   `null`과 함께 안전하세 사용될 수 있는 유일한 연산자는 `is null`과 `is not null`이다.

