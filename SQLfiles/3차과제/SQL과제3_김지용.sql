/*
1. 아래와 같이 DEPT Table,EMP Table을 참조하여 직원이 존재하지 않은 부서(DEPTNO) 관련 정보가 하시요.
( not exists, not in, outer join 을 이용하여 3개 작성)
*/

SELECT d.deptno,d.dname,d.loc,e.empno
FROM dept d left outer join emp e on d.deptno=e.deptno;

SELECT d.deptno,d.dname,d.loc
FROM dept d left outer join emp e
on d.deptno=e.deptno
where e.deptno is null;

select d.deptno,d.dname,d.loc
from dept d
where d.deptno not in (select deptno from emp);

select d.deptno,d.dname,d.loc
from dept d
where not exists (select 1 from emp e where d.deptno = e.deptno);


/*
2. 아래와 같이 EMP Table의 상급자(MGR)의 이름이 조회되도록 하시요. 
단 JOB이 PRESIDENT,MANAGER,SALESMAN,ANALYST,CLERK 순으로 조회되도록 하시요.
*/
select e.EMPNO, e.ENAME,e.job, e.mgr , e2.ename 
from emp e left outer join emp e2
on e.mgr = e2.empno
order by (CASE WHEN job = 'PRESIDENT' THEN 1 
           WHEN job = 'MANAGER' THEN 2
           WHEN job = 'SALESMAN' THEN 3
           WHEN job = 'ANALYST' THEN 4
           WHEN job = 'CLERK' THEN 5 END);

/*
3. 아래와 같이 SALGRADE Table ,EMP Table을 참조하여
GRADE별 몇 명인지  조회하는 SQL을 작성하시요
*/

select * from SALGRADE;
select grade,count(grade) from emp e, salgrade s
where s.losal <= e.sal and e.sal <= s.hisal
group by grade
order by grade;

/*
4. 부서 평균 급여 미만인 직원에 대해 급여를 10% 인상하는 Update 문을 작성하시요.
*/
update emp e set sal=sal*1.1
WHERE sal < (SELECT AVG(SAL) from emp where e.deptno=deptno);

select * from emp;
rollback;
