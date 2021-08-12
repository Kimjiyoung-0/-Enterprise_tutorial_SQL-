/*
1. 아래와 같이 EMP Table을 사용하여 부서별 
MAX SAL,MIN SAL,AVG SAL(소수점 절삭),건수 
그리고 전체 MAX SAL,MIN SAL,AVG SAL(소수점 절삭),건수를 구하시요.

( 1개는 Inline View를 통해 작성하고 1개는 Analytic Function을 사용하여 EMP Table 한번만 조회하도록 작성)

*/

/*INline View*/
SELECT b.EMPNO, b.ENAME, b.DEPTNO, b.SAL, 
MAX_DEPT_SAL, MIN_DEPT_SAL,AVG_DEPT_SAL,COUNT_DEPT,
MAX_SAL,MIN_SAL,AVG_SAL,COUNT_ALL
FROM(select max(sal) as MAX_SAL, 
            min(sal) as MIN_SAL,
            round(avg(sal)) as AVG_SAL,
            count(empno) as COUNT_ALL
            from emp ),
            
    (select deptno,
            max(sal) as MAX_DEPT_SAL, 
            min(sal) as MIN_DEPT_SAL,
            round(avg(sal)) as AVG_DEPT_SAL,
            count(empno) as COUNT_DEPT
            from emp 
            group by deptno) a
            , emp b
where b.deptno= a.deptno;

/*정렬함수*/
SELECT a.empno,a.ename,a.deptno,a.sal
MAX_DEPT_SAL, MIN_DEPT_SAL,AVG_DEPT_SAL,COUNT_DEPT,
MAX_SAL,MIN_SAL,AVG_SAL,COUNT_ALL
from
(select e.*,
max(sal) over(partition by deptno) MAX_DEPT_SAL,
min(sal) over(partition by deptno) MIN_DEPT_SAL,
round(avg(sal) over(partition by deptno)) AVG_DEPT_SAL,
count(empno) over(partition by deptno) COUNT_DEPT,
max(sal) over() MAX_SAL,
min(sal) over() MIN_SAL,
round(avg(sal) over()) AVG_SAL,
count(empno) over() COUNT_ALL
FROM EMP e)a;




/*

2. 아래와 같이 EMP Table을 사용하여 부서별 
SAL,HIREDATE 순 Numbering, 누적 
SAL을 Analytic Function을 사용하여 구하시요. 
*/
SELECT empno,ename,DEPTNO,SAL,hiredate,NUM_sal,CUMM_SAL
from
(select e.*,
sum(sal) over(partition by deptno order by sal, hiredate) CUMM_SAL,
count(empno)over(partition by deptno order by sal, hiredate) NUM_sal
FROM EMP e)
;



/*
3. 아래와 같이 2번 SQL을 참조하여 부서별로 
SAL,HIREDATE 순으로 ENAME을 나열하는 SQL을 작성하시요.

*/

select deptno, ename, NUM_sal
from
(select e.*,
count(empno)over(partition by e.deptno order by sal, hiredate) NUM_sal
FROM EMP e) a
order by deptno;

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




