/*
1. 아래와 같이 emp table의 각 로우가 2번씩 조회되도록 하되 gubun 컬럼을 두어 empno 컬럼값을 구분하도록 한다. 총 28건 조회되며 순서는 empno 컬럼순으로 조회되도록 함. 
(join으로 1개,compound operator 사용하여 1개)
*/
/*join*/

select gunbun, empno,ename,job,mgr,hiredate,sal,comm,deptno
from 
    (
    select rownum gunbun,empno 
    from emp
    union all
    select rownum gunbun ,empno 
    from emp
    ) j 
natural join 
emp e
order by gunbun,empno  ;

/*union*/
select rank() over (order by empno) gunbun,
empno,ename,job,mgr,hiredate,sal,comm,deptno 
from emp
union all
select rank() over (order by empno)gunbun,
empno, ename,job,mgr,hiredate,sal,comm,deptno 
from emp
order by gunbun;

/*
2. 아래와 같이 emp table의 
각 로우가 2번씩 조회되도록 하되 
gubun 컬럼을 두어 첫번째 로우와 두번째 
로우를 구분하는 컬럼을 둔다. 총 28건 조회되며 순서는 empno 와 gubun 컬럼순으로 조회되도록 함. 
*/
/*union*/
select 1 gunbun, empno, ename,job,mgr,hiredate,sal,comm,deptno 
from emp
union all
select 2 gunbun,empno, ename,job,mgr,hiredate,sal,comm,deptno 
from emp
order by empno, gunbun;

/*join*/
select * from
    (
    select 1 gunbun 
    from dual 
    union 
    select 2 
    gunbun 
    from dual ) 
natural join 
    (select * from emp)
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
    to_char(sysdate,'yyyy/')||
    to_char(lpad(level, 2, '0'))||
    '/01' as saldate
    from dual 
    connect by level <= 12
    );

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
    select to_char(sysdate,'yyyy/')||
    to_char(lpad(level, 2, '0'))||
    '/01' as saldate
    from dual 
    connect by level <= 12
    );