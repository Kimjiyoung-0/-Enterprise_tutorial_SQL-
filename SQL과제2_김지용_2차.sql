/*
1. �Ʒ��� ���� EMP Table�� �����Ͽ� 
�μ� ��� �޿�(�Ҽ��� �ݿø�) �̻��� 
����� ��ȸ�ϴ� SQL�� �ۼ��ϵ� �޿� �� 
�μ� ��� �޿� ���� ū ��������� �������� �Ͻÿ�
*/
SELECT e.DEPTNO,e.empno,e.ename,e.SAL,trunc(a.avg_sal) as AVG_SAL
FROM EMP e, (select deptno, avg(sal) as avg_sal
             from emp
             group by deptno) a
WHERE sal > a.avg_sal
and e.deptno = a.deptno
order by abs(sal-avg_sal) desc;
/*
=> Inline View,Join�� �̿��Ͽ� emp table 2���� access �Ͽ� �ٽ� © ��.
*/


/*
2. �Ʒ��� ���� ������� ������ �Ⱓ(�� ����)�� 
�ⰳ���� ���ϵ� ������ ��������� ��ȸ�ϴ� SQL�� �ۼ��Ͻÿ�
*/
select EMPNO, ENAME, HIREDATE,
trunc(months_between(sysdate,hiredate)/12)||' �� '
||trunc(mod(months_between(sysdate,hiredate),12))||' ����'as TORAL_WORKING_PERIOD   
from emp 
order by sysdate-hiredate desc;
/*
==> ����� ���߿����� �ٸ� .��?
*/

/*
3. �μ� ��� �޿� �̸��� ������ ���� 
�޿��� 10% �̻� �λ��Ͽ� �Ʒ��� ���� 
�޿� ���� ������ ��ȸ�ǵ��� �ϴ� SQL�� �ۼ��Ͻÿ�.
*/

SELECT e.DEPTNO,e.empno,e.SAL,
case when sal < a.avg_sal then sal*1.1 else sal end as TOTAL_SAL
    FROM EMP e , (select deptno, avg(sal) as avg_sal
             from emp
             group by deptno) a
order by abs(sal) desc;

/*
 ==> Inline View,Join�� �̿��Ͽ� emp table 2���� access �Ͽ� �ٽ� © ��
*/

/*
4. �μ� ��� �޿� �̸��� ������ ���� �޿��� 10% �λ��ϴ� Update ���� �ۼ��Ͻÿ�.
*/
update emp e set sal=sal*1.1
WHERE sal < (SELECT AVG(SAL) from emp where e.deptno=deptno);

/*
 ==> round�� �� ����߳�?
*/
select * from emp;
rollback;
