/*
1. 아래와 같이 EMP Table을 참조하여 
부서 평균 급여(소수점 반올림) 이상인 
사람을 조회하는 SQL을 작성하되 급여 와 
부서 평균 급여 차가 큰 사람순으로 나오도록 하시요
*/
SELECT e.DEPTNO,e.empno,e.ename,e.SAL,trunc(a.avg_sal) as AVG_SAL
FROM EMP e, (select deptno, avg(sal) as avg_sal
             from emp
             group by deptno) a
WHERE sal > a.avg_sal
and e.deptno = a.deptno
order by abs(sal-avg_sal) desc;
/*
=> Inline View,Join을 이용하여 emp table 2번만 access 하여 다시 짤 것.
*/


/*
2. 아래와 같이 현재까지 재직한 기간(일 절삭)을 
년개월을 구하되 오래된 사람순으로 조회하는 SQL을 작성하시요
*/
select EMPNO, ENAME, HIREDATE,
trunc(months_between(sysdate,hiredate)/12)||' 년 '
||trunc(mod(months_between(sysdate,hiredate),12))||' 개월'as TORAL_WORKING_PERIOD   
from emp 
order by sysdate-hiredate desc;
/*
==> 결과가 박중원씨랑 다름 .왜?
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
order by abs(sal) desc;

/*
 ==> Inline View,Join을 이용하여 emp table 2번만 access 하여 다시 짤 것
*/

/*
4. 부서 평균 급여 미만인 직원에 대해 급여를 10% 인상하는 Update 문을 작성하시요.
*/
update emp e set sal=sal*1.1
WHERE sal < (SELECT AVG(SAL) from emp where e.deptno=deptno);

/*
 ==> round는 왜 사용했나?
*/
select * from emp;
rollback;
