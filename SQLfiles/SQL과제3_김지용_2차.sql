
/*
4. �μ� ��� �޿� �̸��� ������ ���� �޿��� 10% �λ��ϴ� Update ���� �ۼ��Ͻÿ�.
==> �μ� ��� �޿��� 10% �ش��ϴ� �޿��� �λ��ϴ� Update ���� �ۼ�
*/


update emp e set sal=sal+round((SELECT AVG(SAL) as avg_sal from emp where e.deptno=deptno)*0.1)
WHERE sal < (SELECT AVG(SAL) from emp where e.deptno=deptno);


select * from emp;
rollback;
