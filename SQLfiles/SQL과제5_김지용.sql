/*
1. �Ʒ��� ���� emp table�� �� �ο찡 2���� ��ȸ�ǵ��� �ϵ� gubun �÷��� �ξ� empno �÷����� �����ϵ��� �Ѵ�. �� 28�� ��ȸ�Ǹ� ������ empno �÷������� ��ȸ�ǵ��� ��. 
(join���� 1��,compound operator ����Ͽ� 1��)
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
2. �Ʒ��� ���� emp table�� 
�� �ο찡 2���� ��ȸ�ǵ��� �ϵ� 
gubun �÷��� �ξ� ù��° �ο�� �ι�° 
�ο츦 �����ϴ� �÷��� �д�. �� 28�� ��ȸ�Ǹ� ������ empno �� gubun �÷������� ��ȸ�ǵ��� ��. 
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
3. �Ʒ��� ���� emp table�� �����Ͽ� 
�ݳ� �ſ� 1�Ͽ� �ش��ϴ�  sal_date �÷���
��ȸ�ǵ��� �Ͽ� 2020�⵵ ���� �� 14*12 ���� ��ȸ�ǵ��� ��. 
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
4. 3�� ���� ����Ͽ� �Ʒ��� 
���� ���� sal sum�� �������� �Ͽ� 
�� 14*12 ���� ��ȸ�ǵ��� ��. 
rollup ������� ����..
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