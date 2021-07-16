/*
1. �Ʒ��� ���� DEPT Table,EMP Table�� �����Ͽ� ������ �������� ���� �μ�(DEPTNO) ���� ������ �Ͻÿ�.
( not exists, not in, outer join �� �̿��Ͽ� 3�� �ۼ�)
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
2. �Ʒ��� ���� EMP Table�� �����(MGR)�� �̸��� ��ȸ�ǵ��� �Ͻÿ�. 
�� JOB�� PRESIDENT,MANAGER,SALESMAN,ANALYST,CLERK ������ ��ȸ�ǵ��� �Ͻÿ�.
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
3. �Ʒ��� ���� SALGRADE Table ,EMP Table�� �����Ͽ�
GRADE�� �� ������  ��ȸ�ϴ� SQL�� �ۼ��Ͻÿ�
*/

select * from SALGRADE;
select grade,count(grade) from emp e, salgrade s
where s.losal <= e.sal and e.sal <= s.hisal
group by grade
order by grade;

/*
4. �μ� ��� �޿� �̸��� ������ ���� �޿��� 10% �λ��ϴ� Update ���� �ۼ��Ͻÿ�.
*/
update emp e set sal=sal*1.1
WHERE sal < (SELECT AVG(SAL) from emp where e.deptno=deptno);

select * from emp;
rollback;
