
select * from user_tables;
/*
SQL Ű���忡 *�� �����Ͽ� ���̺��� �� ������ ��θ�
���÷��� �� �� ����
selectŰ���� ���Ŀ� ��翭�� �����Ͽ� ���̺���
��� ���� ���÷��� �� �� ����
*/

select * from emp;
select deptno, loc from dept;
/*
�� �̸��� �޸��� �����Ͽ� 
��������ν� ���̺��� Ư�� ����
���÷��� �� �� ����
*/

select ename, sal, sal+300
from emp;
/*
���� ���� ������ �޿��� 300�޷� 
������Ű�� ���� ���������ڸ� ����ϰ�
����� SAL+300 ���� ���÷���
�� sal+300�� dept ���̺��� ���ο� ���� �ƴ�
*/
select ename as name, sal salary
from emp;
select ename "Name", sal*12 "Annual Salary"
From emp;
/*
AS Ű����� ����Ī �̸� �տ� ���
������ ����� �� ����� �빮�ڷ� ��Ÿ��
*/

select ename || job as "Employees"
from emp;
/*
���Ῥ����(||)�� ����Ͽ� ���� ǥ������ �����ϱ� ���� �ٸ���,
��� ǥ���� �Ǵ� ��� ���� ���� ���� �� �� ����
������ ���ʿ� �ִ� ���� ���ϰ�� ���� ����� ���� ���յ�
*/
select ename ||' '||' is a '||' '||job as "Employee Datails"
from emp;
/*
���ͷ��� �� �̸��̳� �� ��Ī�� �ƴ�, 
select ��Ͽ� ���ԵǾ� �ִ� ����, ǥ���� �Ǵ� ������
���ϵǴ� ������ �࿡ ���Ͽ� ��µ�
���ͷ� ��Ʈ���� ���� ����� ���Ե� �� ������ 
SELECT ��Ͽ��� ���� ���� ��޵�
��¥�� ���� ���ͷ��� ���� �ο��ȣ('')���� �־�� ��
*/
select distinct deptno
from emp;
/*
������ ����Ʈ ���÷��̴� �ߺ��Ǵ� ���� �����ϴ� �����
SELECT ������ DISTINCT Ű���带 ����Ͽ� �ߺ��Ǵ� ���� ����
DISTINCT Ű���� �ڿ� ���� ���� ���� ����� �� ����
DISTINCT Ű����� ���õ� ��� ���� ������ ��ġ��, �����
��� ���� distinct�� ������ ��Ÿ��
*/
describe dept;
/*
*/

select ename, job, deptno
from emp
where job='CLERK';
/*
������ select������ ������ cleck�� ���
�������� �̸� ���� �׸��� �μ� ��ȣ�� �˻�
���� clerk�� emp���̺��� job����
��ġ�ǵ��� �ϱ� ���� �빮�ڷ� ���
�Ǿ���Ѵ�.
*/

select ename, job, deptno
from emp
where ename = 'JAMES';
/*
���� ��Ʈ���� ��¥ ���� ���� �ο��ȣ('')�� �ѷ��ο� �ִ�.
���� ���� ��ҹ��ڸ� �����ϰ� ��¥ ���� ��¥ ������ �����Ѵ�.
����Ʈ ��¥ ������ 'DD-MON-YY'�̴�.
*/

select ename, sal
from emp
where sal between 1000 and 1500;
/* ���� ������ �ش��ϴ� ���� ���÷���
�� �� �ִ�. ����� ������ ���� ����
���� ���� �����Ѵ�. �Ʒ��� 
select������ �޿��� $1000 ����
$1500���̿� �ִ� �������� ���ؼ� 
EMP���̺�κ��� ���� ����
*/

select empno, ename, sal, mgr
from emp
where mgr in(7902,7566,7788);
/* ��õ� ��Ͽ� �ִ� ���� ���ؼ� �׽�Ʈ�ϱ� ����, 
�Ʒ��� ���� �������� ������ ��ȣ�� 7902, 7566, 7788�� 
��� �������� ������ ��ȣ, �̸�, �޿� �׸��� �������� ������ ��ȣ��
���÷��� �Ѵ�.
*/

select ename
from emp
where ename like 'S%';
/* like ������ ��� 
�˻� ��Ʈ�� ���� ���� ���ϵ� ī�� �˻��� 
���ؼ� like �����ڸ� ����Ѵ�.
�˻������� ���ͷ� ���ڳ� ���ڸ� ���� �� �� �ִ�.
%�� ���ڰ� ���ų� �Ǵ� �ϳ� �̻��� ��Ÿ����.
_�� �ϳ��� ���ڸ� ��Ÿ����.
*/
select ename, mgr
from emp
where mgr is null;
/*
null���� ���� ���ų� �� �� ���ų� 
�Ǵ� ������ �� ������ �ǹ��Ѵ�.
�׷��Ƿ� null���� � ���� ���ų� 
�Ǵ� �ٸ� �� �����Ƿ� = �δ� �׽�Ʈ �� �� ����.
*/
select empno, ename, job, sal
from emp
where sal>=1100
and job='CLERK';
/*
������ ������ ���̾�� �Ѵ�. ������ CLERK�̰� 
�޿��� $1100�̻��� �������� ���õ�
*/

select empno, ename, job, sal
from emp
where sal>=1100
or job='CLERK';
/*
������ ���Ǹ� ���̸� �ȴ�.
������ CLERK�̰ų� �޿��� $1100�̻���
�������� ���õ�
*/

select ename, job
from emp
where job not in('CLERK','MANAGER','ANALYST');
/*
������ CLERK, MANAGER �Ǵ� ANALYST�� �ƴ�
��� �������� �̸��� ������ 
���÷��� �Ѵ�.
*/


select ename, job, sal
from emp
where job='salesman'
or job='president'
and sal>1500;
/*
������ PRESIDENT�̰� $1500�̻��� ���ų� �Ǵ�
������ SALESMAN�� ���� �˻��Ѵ�.
*/

select ename, job, sal
from emp
where (job='salesman'
or job='president')
and sal>1500;
/*�켱 ������ ������ �ٲٱ� ���ؼ�
��ȣ�� ����Ѵ�.
������ PRESIDENT �̰ų� SALESMAN �̰� 
$1500 �̻��� ���� ���� �˻��Ѵ�.
*/

SELECT ename, job, deptno, hiredate
FROM emp
ORDER BY hiredate;
/*
ASC: �������� , ����Ʈ ����
DESC: ��������
*/

select  ename, job, deptno, hiredate
from emp
order by hiredate DESC;

select empno, ename, sal*12 annsal
from emp
order by annsal;
/*
order by ������ �� ��Ī�� ����� �� �ִ�.
���� �������� �����͸� ����
*/

select ename, deptno, sal
from emp
order by deptno, sal desc;
/*
�ϳ� �̻��� ���� ���� ����� ������ �� �ִ�.
�־��� ���̺� �ִ� ���� ���� ������ ������.
ORDER BY������ ���� ����ϰ� �� �̸��ڿ�
DESC�� ����Ѵ�. SELECT ���� ���Ե��� 
�ʴ� ���� ������ �� ���ִ�.
*/
select ename,(SYSDATE-hiredate)/7 weeks
from emp
where deptno =10;
/*
month_between('01-sep-95','11-jan-94')= 19.6774149,
add_months('11-jan-94',6) = 11-JUL-94,
next_day('01-sep-95','friday') = '08-sep-95',
last_day('01-sep-95') = '30-sep-95',
round('25-jul-95','month') = 01-AUG-95
round('25-jul-95','year') = 01-jan-96
trunc('25-jul-95','month')=01-jul-95
trunc('25-jul-95','year')=04-jan-95
*/
/*
NVL �Լ�
Null ���� ���� ������ ��ȯ
���� �� �ִ� ���������� ��¥, ����, ����.
���������� ��ġ�ؾ� ��.
NVL(comm, 0)
NVL(hiredate,'01-JAN-97')
NVL(job,'No Job Yet')
*/
select job, sal, Decode(job, 'ANALYST', sal * 1.1,
                        'CLERK', sal * 1.15,
                        'MANAGER', sal * 1.20,
                        sal) Revised Salary from EMP;
                        
select avg(salary), min(salary), max(salary), sum(salary)
from employees
where job_id like '%REP%';

select
min(hire_date),max(hire_date)
,min(last_name), max(last_name)
from EMPLOYEES;

select
min(hire_date),max(hire_date),
min(last_name),max(last_name)
from employees;
/*
���ڿ� ��¥�� min-max���
*/
select
count(*),
count(distinct department_id),
count(department_id),
count(all DEPARTMENT_id)
from EMPLOYEES
where department_id = 50;
/*
count ���
*/
select
count(commission_pct),
count(department_id)
from EMPLOYEES
where DEPARTMENT_id = 80;
/*
null ����
*/
select
distinct
count(distinct department_id)
from EMPLOYEES;

select avg(commission_pct), avg(nvl(commission_pct, 0))
from EMPLOYEES;

select DEPARTMENT_id, avg(salary)
from EMPLOYEES
group by department_id;

select
avg(salary)
from EMPLOYEES
group by department_id;

select
DEPARTMENT_id, job_id, sum(salary), avg(salary),
min(salary), max(salary)
from EMPLOYEES
group by DEPARTMENT_id, job_id;

select
DEPARTMENT_id
,count(last_name)
from EMPLOYEES;
/*���� */

select
DEPARTMENT_id
,count(last_name)
from EMPLOYEES
where avg(salary) > 8000
group by DEPARTMENT_id;
/*where�� ������*/

select
department_id
,count(last_name)
from EMPLOYEES
group by DEPARTMENT_id
having avg(salary) > 8000;

select 
DEPARTMENT_id, max(salary)
from EMPLOYEES
group by DEPARTMENT_id
having max(salary) > 10000;

select job_id, sum(salary)
from EMPLOYEES
where job_id not like '%REP%'
group by job_id
having sum(salary) > 1300
order by sum(salary);

select max(avg(salary))
from EMPLOYEES
group by DEPARTMENT_id;

select max(abc)
from (select avg(salary) abc
from EMPLOYEES
group by DEPARTMENT_id)b;

select last_name, DEPARTMENT_name
from EMPLOYEES cross join DEPARTMENTS;
/*CROSS ������ �� ���̺��� �������� �����մϴ�.*/
/*�̴� �� ���̺� ���� Cartesian ���� �����ϴ�.*/

/*
NATURAL ����
*NATURAL ������ �� ���̺��� ���� �̸��� ����
��� Į���� ����մϴ�.
*�� ���̺��� �����Ǵ� ��� �÷��� ����
���� ���� ������ ����� �����մϴ�.
*���� ���� �̸��� ������ �÷����� ����
�ٸ� ������ ���� ���������� ������ ��ȯ�˴ϴ�.
*���� SELECT * ������ ����Ѵٸ�, ���� �÷����� 
������տ��� �� �ѹ��� ��Ÿ���ϴ�.
*���̺� �̸��̳� ���� ���� �����ڵ��� NATURAL
���ο� ���� �÷����� ������ �� �����ϴ�.
*/

select DEPARTMENT_id, location_id
from locations natural join DEPARTMENTS;
/*
using ���� �̿��� ����
���� ���� ���� �÷��� �̸��� ������ ������ ���� ���
��ġ������ ���� ������, NATURAL JOIN�� USING���� 
�̿��Ͽ� ���� ���ο� ���� �÷����� ����ϵ��� ����
�� �� �ֽ��ϴ�.
*USING ������ �����Ǵ� �÷����� SQL �� 
��𿡼��� ������(���̺� �̸��̳� ����)��
���� ���ĵ� �� �����ϴ�.
NATURAL �� USING�� �� Ű����� ��ȣ ��Ÿ������
���˴ϴ�.
*/
select e.EMPLOYEE_id, e.last_name, d.LOCATION_id
from EMPLOYEES e join DEPARTMENTS d
using (DEPARTMENT_id);

/*
on ���� ����ϴ� ����
Natural ������ ���� ������ �⺻������ ���� �̸��� ���� ���
�÷��鿡 ���� ���� �����Դϴ�.

������ ���� ������ �����ϰų�, �Ǵ� ������ �÷��� ����ϱ�
���ؼ� on���� ���˴ϴ�.

on���� ���� ���ǰ� �ٸ� ���ǵ��� �и��մϴ�.
on���� �ڵ带 ���� �����ϱ� ���� �մϴ�.
*/
select e.employee_id, e.last_name, e.department_id, d.department_id,
d.location_id
from EMPLOYEES e join DEPARTMENTS d
on(e.department_id = d.department_id);
/*
������ ����
On���� ��������ν� ������ �����͵��� �̿��� ������ 
������ ���� �� �ֽ��ϴ�.

���� ���ǰ� on��
on���� ��������ν� �ٸ����ǰ� ���� ������ �и���ų�� �ֽ��ϴ�.
�׷��� �ϸ� �ڵ尡 ���� �����ϱ� �������ϴ�.
on���� ���������� �� ������ ���� ������ ������ ������
������ �� �ֽ��ϴ�.
*/
select e.manager_id, e.last_name ,
d.department_id, d.location_id
from EMPLOYEES e join DEPARTMENTS d
on((e.department_id = d.DEPARTMENT_id)
    and
    e.manager_id =102
);

select DEPARTMENT_name, city
from locations l join DEPARTMENTS d
on((l.location_id = d.LOCATION_id)
    and not exists(
    select 1 from EMPLOYEES e
    where e.DEPARTMENT_id = d.DEPARTMENT_id
    )
);

select EMPLOYEE_id, city, DEPARTMENT_name
from LOCATIONS l
join DEPARTMENTS d
on (l.LOCATION_id = d.LOCATION_id)
join EMPLOYEES e
on (d.DEPARTMENT_id = e.department_id);

/*
INNER �� OUTER ����
SQL : �����̺��� �����Ͽ� ������
�����Ǵ� ��鸸�� ��ȯ�ϴ� ����
INNER �����̶� �մϴ�.

INNER ������ ��� �Բ� ����(������) ���̺��� ��������
�ʴ� ��鵵 ��ȯ�ϴ� ���� LEFT (RIGHT) OUTER �����̶�� �մϴ�.

INEER ������ ����� �Բ� LEFT �� RIGHT OUTER
������ ������� ��� ��ȯ�ϴ� ���� FULL OUTER ����
�̶� �մϴ�.
*/

select e.last_name, d.DEPARTMENT_name
from EMPLOYEES e left outer join DEPARTMENTS d
on(e.DEPARTMENT_id = d.DEPARTMENT_id);

select e.last_name, d.DEPARTMENT_name
from EMPLOYEES e right outer join DEPARTMENTS d
on(e.DEPARTMENT_id = d.DEPARTMENT_id);

select e.last_name, d.DEPARTMENT_name
from EMPLOYEES e full outer join DEPARTMENTS d
on(e.DEPARTMENT_id = d.DEPARTMENT_id);

/*
�ϳ� �̻��� ���̺�κ��� �����͸� �����ϱ� ���ؼ� JOIN�� �����.
���̺��� ���� ���õǴ� ���� ���� ��(Primary Key �� Foreign Key)���� ����
�ٸ� �ϳ��� ���̺��� ��� Join�� �� ����.

WHERE ���� ���� ����(Join Condition)�� �ۼ���.
�ϳ� �̻��� ���̺� �Ȱ��� �� �̸��� ������,
�� �̸��տ� ���̺� �̸��� ����.
*/

select emp.empno, emp.ename, emp.deptno, dept.deptno, dept.loc
from emp join dept
on emp.deptno = dept.deptno;

select e.empno, e.ename, e.deptno, d.deptno, d.loc
from emp e join dept d
on e.deptno = d.deptno;

select e.ename, e.sal, s.grade
from emp e join SALGRADE s
on e.sal between s.losal and s.hisal;

select e.ename, d.deptno, d.dname
from emp e right outer join dept d
on e.deptno = d.deptno order by e.deptno;

select worker.ename || 'works for' || manager.ename
from emp worker join emp manager
on worker.mgr = manager.empno;
/*
���������� �ذ� �� �� �ִ� ������ ������ ���
���������� ����
���������� ������ ����
���� �� ���������� ���� �� ���������� �ۼ�
*/

select ename
from emp
where sal> (select sal from emp where empno=7566);

/*
�������� �����ħ
*���������� ��ȣ�� �ѷ��ο��� ��
*���������� �� �������� �����ʿ� ��ġ �Ͽ�����
*���������� ORDER BY���� �������� �� ��
*select ���忡�� ���� �ϳ��� order by ���� �� �� 
������ ������ ���� ��ġ�Ͽ��� ��
*���� �� ������������ ���� �� �����ڸ� ���
*���� �� ������������ ���� �� �����ڸ� ���
*/
select ename,job
from EMP
where job= (select job from emp where empno=7369)
and sal > (select sal from emp where empno=7876);

select ename, job, SAL
from EMP
where sal = (select min(sal) from emp);

select deptno, MIN(sal)
from EMP
group by deptno
having min(sal) >(select min(sal) from emp where deptno =20);
/*
���� �� ��������
in ����� � �������� ����
any ���� ���������� ���� ���ϵ� ������ ���� ���Ѵ�
all ���� ���������� ���� ���ϵǴ� ��� ���� ���Ѵ�
*/

select empno, ename, job
from EMP
where sal<ANY(select sal from emp where job='CLERK')
AND job<>'CLERK';

select empno, ename, job
from EMP
where sal> all(select avg(sal) from emp group by deptno);

/*
���������� �ٸ� SQL ������ ���� �����
SELECT������ �������� ���� �ٰŷ� �� �� 
������
*�������� �� ���� =,<>,>,>=,<,<=���� ���� �� �����ڸ�
�����ϴ� ���� �������� ������ �� ����
*�������� ���� ���� IN �� ���� ���� ��
�����ڸ� �����ϴ� ���ι������� ������ �� ����
*���������� ����Ŭ ������ ���ؼ� ���� ó���� ������ 
Where �Ǵ� Having���� �� ����� ���
*�׷��Լ��� ������ �� ����
*/