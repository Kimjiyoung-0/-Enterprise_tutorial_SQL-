/*
1. 아래와 같이 EMP Table을 참조하여 
부서 평균 급여(소수점 반올림) 이상인 
사람을 조회하는 SQL을 작성하되 급여 와 
부서 평균 급여 차가 큰 사람순으로 나오도록 하시요
*/
SELECT e.DEPTNO,e.empno,e.ename,e.SAL,round(a.avg_sal) as AVG_SAL
FROM EMP e, (select deptno, avg(sal) as avg_sal
             from emp
             group by deptno) a
WHERE sal > a.avg_sal
and e.deptno = a.deptno
order by abs(sal-avg_sal) desc;
/*
=> trunc(a.avg_sal) 가 소수점 반올림 맞나?
*/


/*
3. 부서 평균 급여 미만인 직원에 대해 
급여를 10% 이상 인상하여 아래와 같이 
급여 높은 순으로 조회되도록 하는 SQL을 작성하시요.
*/

SELECT e.DEPTNO,e.empno,e.SAL,
case when sal < a.avg_sal then sal*1.1 else sal end as TOTAL_SAL
    FROM EMP e , (select deptno, avg(sal) as avg_sal
             from emp
             group by deptno) a
where e.deptno = a.deptno
order by abs(sal) desc;

/*
 ==> Join 조건이 없슴
*/


