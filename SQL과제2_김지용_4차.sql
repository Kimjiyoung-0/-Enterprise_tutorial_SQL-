/*
1. 아래와 같이 EMP Table을 참조하여 
부서 평균 급여(소수점 반올림) 이상인 
사람을 조회하는 SQL을 작성하되 급여 와 
부서 평균 급여 차가 큰 사람순으로 나오도록 하시요
*/

SELECT DEPTNO,empno,ename,SAL, avg_sal
from
(select e.*,round(avg(sal) over(partition by deptno)) avg_SAL FROM EMP e)
where sal > avg_sal
order by abs(avg_sal) desc;



/*
3. 부서 평균 급여 미만인 직원에 대해 
급여를 10% 이상 인상하여 아래와 같이 
급여 높은 순으로 조회되도록 하는 SQL을 작성하시요.
*/


SELECT DEPTNO,empno,SAL,
case when sal < avg_sal then sal*1.1 else sal end as TOTAL_SAL
from
(select e.*,round(avg(sal) over(partition by deptno)) avg_SAL FROM EMP e)
order by abs(sal) desc;



