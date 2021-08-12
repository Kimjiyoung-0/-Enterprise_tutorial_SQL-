/*
1. 아래와 같이 EMP Table을 참조하여 SAL (급여) + COMM (커미션)을
더한 총 수입을 낮은 순으로 조회하는 SQL을 작성하시요.
단 총 수입이 같은 경우 HIREDATE(입사일)이 최근인 경우가 먼저 조회되도록 하시요.
*/
select empno,sal,nvl(comm,0) comm,hiredate,sal+nvl(comm,0) total_income 
from emp
order by total_income, hiredate desc;

/*
2. 아래와 같이 현재까지 재직한 기간(소수점 절삭)을
구하되 오래된 사람순으로 조회하는 SQL을 작성하시요.
*/
select empno, ename, hiredate, trunc(sysdate - hiredate) TOTAL_WORKING_PERIOD
from emp
order by TOTAL_WORKING_PERIOD desc;
/*
3. 아래와 같이 DEPTNO (부서) 별로 최소 급여,최대 급여,
총 급여,구성원 수,평균 급여(소수점 절삭)를 높은 평균 급여 순으로 조회하는 SQL을 작성하시요.
*/
select deptno, min(sal) SAL_MIN,max(sal) SAL_MAX,sum(sal) SAL_SUM,count(deptno) DEPT_COUNT,trunc(avg(sal)) AVG_SAL
from emp
GROUP BY DEPTNO
order by AVG_SAL desc;
/*
4. 아래와 같이 부서별로 구성원 수가 
5명 이상인 부서와 구성원을 구하는 SQL을 작성하시요.
*/
SELECT DEPTNO, COUNT(DEPTNO) DEPT_COUNT
FROM EMP
GROUP BY DEPTNO
HAVING COUNT(DEPTNO)>=5;

