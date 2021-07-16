/*
1. �Ʒ��� ���� EMP Table�� �����Ͽ� 
�μ� ��� �޿�(�Ҽ��� �ݿø�) �̻��� 
����� ��ȸ�ϴ� SQL�� �ۼ��ϵ� �޿� �� 
�μ� ��� �޿� ���� ū ��������� �������� �Ͻÿ�
*/

SELECT DEPTNO,empno,ename,SAL, avg_sal
from
(select e.*,round(avg(sal) over(partition by deptno)) avg_SAL FROM EMP e)
where sal > avg_sal
order by abs(avg_sal) desc;



/*
3. �μ� ��� �޿� �̸��� ������ ���� 
�޿��� 10% �̻� �λ��Ͽ� �Ʒ��� ���� 
�޿� ���� ������ ��ȸ�ǵ��� �ϴ� SQL�� �ۼ��Ͻÿ�.
*/


SELECT DEPTNO,empno,SAL,
case when sal < avg_sal then sal*1.1 else sal end as TOTAL_SAL
from
(select e.*,round(avg(sal) over(partition by deptno)) avg_SAL FROM EMP e)
order by abs(sal) desc;



