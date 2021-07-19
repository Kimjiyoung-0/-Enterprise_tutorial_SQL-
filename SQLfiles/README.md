# SQL실습 내용
## 인 라인뷰 
EMP Table을 참조하여 
부서 평균 급여(소수점 반올림) 이상인 <br>
사람을 조회하는 SQL을 작성하되 급여 와 <br>
부서 평균 급여 차가 큰 사람순으로 나오도록 하시요<br>

이러한 문제가 있다고 가정할 때 <br>
가장 문제가 되는 지점은 <br>
각 직원마다 부서별로 다른 평균이<br>
적용되야 한다는 점이 골치 아플것이다.<br>

직원마다 각 부서별의 평균을 따로 적용해야하니 <br>
emp테이블을 여러번 써야할것 같지만 <br>
인라인뷰를 이용하면 단두번만 <br>
이용하면 해결할수 있다.<br>
```SQL
SELECT e.DEPTNO,e.empno,e.ename,e.SAL,trunc(a.avg_sal) as AVG_SAL
FROM EMP e, (select deptno, avg(sal) as avg_sal
             from emp
             group by deptno) a
WHERE sal > a.avg_sal
and e.deptno = a.deptno
order by abs(sal-avg_sal) desc;
```
이런식으로 아예 from 절에 내가 필요한 정보를 가져와놓고,<br>
where으로 부서번호에 맞게 분리 시킨다.<br>
그러면 각 부서별 평균과 그 직원의 월급을 비교할 수 있다.<br>

## 특정값으로 order by 정렬
SQL에서 order by는 그 값(문자열, 숫자)에 맞게<br>
테이블을 정렬해주는 문구이다. 허나, 내가원하는 값으로<br>
예를 들면 직급으로 정렬을 해야한다면 어떻게 하는가<br>

이럴때는 CASE WHEN을 사용한다.<br>

예를 들어
단 JOB이 PRESIDENT,MANAGER,SALESMAN,ANALYST,CLERK 순으로 조회되도록 하시요.<br>
이러한 문제 가있을 경우 order by 문에<br>
```SQL
order by (CASE WHEN job = 'PRESIDENT' THEN 1 
           WHEN job = 'MANAGER' THEN 2
           WHEN job = 'SALESMAN' THEN 3
           WHEN job = 'ANALYST' THEN 4
           WHEN job = 'CLERK' THEN 5 END);
```
이렇게 적어주면 된다.<br>

## not equi 조인 
Equi 조인은 특정 테이블에 값이 같을때 작동한다<br>
예)emp 테이블의 deptno과 dept테이블의 deptno<br>
허나 이 조인은 값이 정확하게 맞을때만 작동이 된다.<br>
내가 특정영역별로 조인을 할려고하면 다른방식을 써야하는데,<br>
그게 바로 non equi 조인이다.<br>

예를 들어 <br>
 SALGRADE Table ,EMP Table을 참조하여<br>
GRADE별 몇 명인지  조회하는 SQL을 작성하시요<br>
(SALGRADE 테이블에 얼마에따라 어느 등급인지 정보가 들어가있음)<br>
라는 문제를 풀때 non Equi 조인을 사용하여 <br>
```SQL
select * from SALGRADE;
select grade,count(grade) from emp e, salgrade s
where s.losal <= e.sal and e.sal <= s.hisal
group by grade
order by grade;
```

이렇게 작성할 수 있다. 이러면 SALGRADE 테이블의 <br>
등급의 가장낮은 월급값에서 가장 높은 월급사이에 있는 월급값을<br>
매칭 시킬수 있다.<br>

## Oracle Analytic Function(분석 함수)
1. 아래와 같이 EMP Table을 참조하여 <br>
부서 평균 급여(소수점 반올림) 이상인 <br>
사람을 조회하는 SQL을 작성하되 급여 와 <br>
부서 평균 급여 차가 큰 사람순으로 나오도록 하시요<br>

라는 문제를 인라인뷰로 emp 테이블에 두번 엑세스하여 <br>
해결하였다. 허나 Oracle Analytic Function을 사용하면 <br>
단 한번만 emp테이블을 액세스하여 문제를 해결할 수 있다.<br>

Oracle Analytic Function는 <br>
하나의 그룹으로부터 여러 통계 값이나 계산된 값을 여러개의 <br>
행으로 반환하는 함수 <br>
분석함수용 그룹(윈도우)을 따로 지정하여 그 그룹을 대상으로 계산을 수행한다.<br>
형식은<br>
윈도우 함수 (파라미터1,파라미터2.......)OVER (<br>
                    PARTITION BY 표현식<br>
                    ORDER BY 표현식 [ASC|DESC]<br>
)<br>
위에 있던 문제를 이 분석함수를 이용해 풀어보면<br>

```SQL
SELECT DEPTNO,empno,ename,SAL, avg_sal
from
(select e.*,round(avg(sal) over(partition by deptno)) avg_SAL FROM EMP e)
where sal > avg_sal
order by abs(avg_sal) desc;
```

이렇게 된다. <br>
from에 deptno별로(부서별로) 평균을 계산해 그값을 <br>
쏴주는 형태다.<br>
## NOT IN과 NOT EXISTS의 차이점
예를 들어 가상으로 not in을 쓴 SQL문, NOT EXISTS를 쓴 SQL문이 있다고 하자<br>
```SQL
SELECT *
FROM TEST! A
WHERE A.NO NIT IN (SELECT NO FROM TEST2)

SELECT * FROM TEST1 A
WHERE NOT EXISTS(SELECT 1 FROM TEST2 B WHERE A.NO = B.NO)
```

이 둘의 차이는 NULL값이 나오냐 안나오냐에 있다.<br>

NOT IN의 경우 <br>
where절의 조건이 맞는지 틀리는지를 찾는것이다.<br>
그런데 NULL은 조인에 참여하지 않기때문에 결과에서 빠지게된다.<br>
여기서 TEST1의 NULL값이 나오지 않은 이유는 IN 서브쿼리의<br>
결과에 NULL유무에 영향을 받지 않는다<br>
즉, TEST2의 NO컬럼에 NULL값이 없어도<br>
TEST1의 NO컬럼의 NULL값은 결과에 나오지 않는다.<br>

NOT EXISTS의 경우<br>
EXISTS는 서브쿼리가 TRUE인지 FALSE인지 체크하는 것이므로<br>
NOT EXISTS는 서브쿼리가 FALSE이면 전체적으로 TRUE가 됩니다.<br>
서브쿼리에서 TEST1과 TEST2의 조인시 NULL은 결과에서  빠지게 됩니다.<br>
이것은 서브쿼리를 FALSE로 만들게 되고<br>
전체적으로 TRUE가 되어 TEST1의 NULL값이 결과에 나오게 됩니다.<br>

## 세로로 출력되는 데이터를 가로쓰기

3.부서별로 SAL 순으로 ENAME을 나열하는 SQL을 작성하시요.<br>
라는문제 가 있다고하자 그러면 간단하게<br>
```SQL
select deptno,num_sal,ename
from
(select e.*,
count(empno)over(partition by e.deptno order by sal, hiredate) NUM_sal
FROM EMP e) a
order by deptno;
```
이런 문장으로 처리할 수 있다.<br>

허나, 세로로 나오는 데이터를 가로로 출력해야한다면 어떻게 할까<br>

먼저 셀렉트 문을 잘 설계해보자 . <br>
세로로나오는 데이터를 가로로 출력할려면, 셀렉트 절에 많은 인자가 들어갈 것이다.<br>
```SQL
select deptno,
decode(num_sal,1,ename,null) as ename_1,
decode(num_sal,2,ename,null) as ename_2,
decode(num_sal,3,ename,null) as ename_3,
decode(num_sal,4,ename,null) as ename_4,
decode(num_sal,5,ename,null) as ename_5,
decode(num_sal,6,ename,null) as ename_6
from
(select e.*,
count(empno)over(partition by e.deptno order by sal, hiredate) NUM_sal
FROM EMP e) a
order by deptno;
```
이것을 출력하면 빈칸이 중간에 끼어있긴하지만,<br>
가로로 출력하는데는 성공한다.<br>

그러면 이제 어떻게 빈칸을 없앨까<br>
바로 그룹바이와, max함수를 사용한다.<br>

```SQL
select deptno,
max(decode(num_sal,1,ename,null)) as ename_1,
max(decode(num_sal,2,ename,null)) as ename_2,
max(decode(num_sal,3,ename,null)) as ename_3,
max(decode(num_sal,4,ename,null)) as ename_4,
max(decode(num_sal,5,ename,null)) as ename_5,
max(decode(num_sal,6,ename,null)) as ename_6
from
(select e.*,
count(empno)over(partition by e.deptno order by sal, hiredate) NUM_sal
FROM EMP e) a
group by deptno
order by deptno;
```
이런식으로 출력하면 내가 원하는 값만 뽑아올 수 있다.<br>
