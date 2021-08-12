
/*
4. 부서 평균 급여 미만인 직원에 대해 급여를 10% 인상하는 Update 문을 작성하시요.
==> 부서 평균 급여의 10% 해당하는 급여를 인상하는 Update 문을 작성
*/


update emp e set sal=sal+round((SELECT AVG(SAL) as avg_sal from emp where e.deptno=deptno)*0.1)
WHERE sal < (SELECT AVG(SAL) from emp where e.deptno=deptno);


select * from emp;
rollback;
