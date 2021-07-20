/*
1. 아래와 같이 emp table의 각 로우가 2번씩 조회되도록 하되 gubun 컬럼을 두어 empno 컬럼값을 구분하도록 한다. 총 28건 조회되며 순서는 empno 컬럼순으로 조회되도록 함. 
(join으로 1개,compound operator 사용하여 1개)
*/
/*join*/

select e.*
from 
    (
    select level
    from dual 
    connect by level <= 2
    )  
cross join 
    (
    select rownum gunbun, emp.*
    from 
        (
        select *
        from emp 
        order by empno
        )emp
    ) e
order by gunbun,empno  ;

==> Analytic Function 사용하지 말 것.;

/*union*/
select rownum gunbun,emp.*
from emp
union all
select rownum gunbun,emp.*
from emp
order by gunbun;

==> Analytic Function 사용하지 말 것.;
/*
2. 아래와 같이 emp table의 
각 로우가 2번씩 조회되도록 하되 
gubun 컬럼을 두어 첫번째 로우와 두번째 
로우를 구분하는 컬럼을 둔다. 총 28건 조회되며 순서는 empno 와 gubun 컬럼순으로 조회되도록 함. 
*/
/*union*/
select *
from
(
    (
    select 1 gunbun, e.*
    from emp e
    )
    union all
    (
    select 2 gunbun, e2.*
    from emp e2
    )
)
order by empno, gunbun;

/*join*/
select * from
    (
    select level gunbun
    from dual 
    connect by level <= 2
    ) 
natural join 
    (
    select * 
    from emp
    )
order by empno, gunbun;

/*
3. 아래와 같이 emp table을 참조하여 
금년 매월 1일에 해당하는  sal_date 컬럼이
조회되도록 하여 2020년도 월별 총 14*12 건이 조회되도록 함. 
*/

select empno,ename,job,hiredate,saldate,sal
from emp
natural join
    (
    select 
    TO_CHAR(ADD_MONTHS(TRUNC(sysdate,'yyyy'), level-1),'yyyy/mm/dd') as saldate
    from dual 
    connect by level <= 12
    );
    
  ==>    to_char(sysdate,'yyyy/')|| to_char(lpad(level, 2, '0'))||'/01' as saldate 부분 date 형을 그대로 두고 다시 작성할 것.;

/*
4. 3번 답을 사용하여 아래와 
같이 월별 sal sum이 나오도록 하여 
총 14*12 건이 조회되도록 함. 
rollup 사용하지 말것..
*/
select empno,ename,job,saldate,sal
from ( 
    select empno,ename,job,sal
    from emp
    union all
    select null,null,null,sum(sal)
    from emp
    )
natural join
    (
    select to_char(ADD_MONTHS(TRUNC(sysdate,'yyyy'), level-1),'yyyy/mm/dd') as saldate
    from dual 
    connect by level <= 12
    );