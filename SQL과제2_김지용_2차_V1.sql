/*
1. �Ʒ��� ���� EMP Table�� �����Ͽ� 
�μ� ��� �޿�(�Ҽ��� �ݿø�) �̻��� 
����� ��ȸ�ϴ� SQL�� �ۼ��ϵ� �޿� �� 
�μ� ��� �޿� ���� ū ��������� �������� �Ͻÿ�
*/
SELECT e.DEPTNO,e.empno,e.ename,e.SAL,round(a.avg_sal) as AVG_SAL
FROM EMP e, (select deptno, avg(sal) as avg_sal
             from emp
             group by deptno) a
WHERE sal > a.avg_sal
and e.deptno = a.deptno
order by abs(sal-avg_sal) desc;
/*
=> trunc(a.avg_sal) �� �Ҽ��� �ݿø� �³�?
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
where e.deptno = a.deptno
order by abs(sal) desc;

/*
 ==> Join ������ ����
*/


