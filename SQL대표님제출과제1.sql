/*
1. �Ʒ��� ���� EMP Table�� �����Ͽ� SAL (�޿�) + COMM (Ŀ�̼�)��
���� �� ������ ���� ������ ��ȸ�ϴ� SQL�� �ۼ��Ͻÿ�.
�� �� ������ ���� ��� HIREDATE(�Ի���)�� �ֱ��� ��찡 ���� ��ȸ�ǵ��� �Ͻÿ�.
*/
select empno,sal,comm,hiredate,sal+nvl(comm,0) total_income 
from emp
order by total_income, hiredate desc;

/*
2. �Ʒ��� ���� ������� ������ �Ⱓ(�Ҽ��� ����)��
���ϵ� ������ ��������� ��ȸ�ϴ� SQL�� �ۼ��Ͻÿ�.
*/
select empno, ename, hiredate, trunc(sysdate - hiredate) TOTAL_WORKING_PERIOD
from emp
order by TOTAL_WORKING_PERIOD desc;
/*
3. �Ʒ��� ���� DEPTNO (�μ�) ���� �ּ� �޿�,�ִ� �޿�,
�� �޿�,������ ��,��� �޿�(�Ҽ��� ����)�� ���� ��� �޿� ������ ��ȸ�ϴ� SQL�� �ۼ��Ͻÿ�.
*/
select deptno, min(sal) SAL_MIN,max(sal) SAL_MAX,sum(sal) SAL_SUM,count(deptno) DEPT_COUNT,trunc(avg(sal)) AVG_SAL
from emp
GROUP BY DEPTNO
order by AVG_SAL desc;
/*
4. �Ʒ��� ���� �μ����� ������ ���� 
5�� �̻��� �μ��� �������� ���ϴ� SQL�� �ۼ��Ͻÿ�.
*/
SELECT DEPTNO, COUNT(DEPTNO) DEPT_COUNT
FROM EMP
GROUP BY DEPTNO
HAVING COUNT(DEPTNO)>=5;

