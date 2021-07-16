/*
1. �Ʒ��� ���� EMP Table�� ����Ͽ� �μ��� 
MAX SAL,MIN SAL,AVG SAL(�Ҽ��� ����),�Ǽ� 
�׸��� ��ü MAX SAL,MIN SAL,AVG SAL(�Ҽ��� ����),�Ǽ��� ���Ͻÿ�.

( 1���� Inline View�� ���� �ۼ��ϰ� 1���� Analytic Function�� ����Ͽ� EMP Table �ѹ��� ��ȸ�ϵ��� �ۼ�)

*/

/*INline View*/
SELECT b.EMPNO, b.ENAME, b.DEPTNO, b.SAL, 
MAX_DEPT_SAL, MIN_DEPT_SAL,AVG_DEPT_SAL,COUNT_DEPT,
MAX_SAL,MIN_SAL,AVG_SAL,COUNT_ALL
FROM(select max(sal) as MAX_SAL, 
            min(sal) as MIN_SAL,
            round(avg(sal)) as AVG_SAL,
            count(empno) as COUNT_ALL
            from emp ),
            
    (select deptno,
            max(sal) as MAX_DEPT_SAL, 
            min(sal) as MIN_DEPT_SAL,
            round(avg(sal)) as AVG_DEPT_SAL,
            count(empno) as COUNT_DEPT
            from emp 
            group by deptno) a
            , emp b
where b.deptno= a.deptno;

/*�����Լ�*/
SELECT a.empno,a.ename,a.deptno,a.sal
MAX_DEPT_SAL, MIN_DEPT_SAL,AVG_DEPT_SAL,COUNT_DEPT,
MAX_SAL,MIN_SAL,AVG_SAL,COUNT_ALL
from
(select e.*,
max(sal) over(partition by deptno) MAX_DEPT_SAL,
min(sal) over(partition by deptno) MIN_DEPT_SAL,
round(avg(sal) over(partition by deptno)) AVG_DEPT_SAL,
count(empno) over(partition by deptno) COUNT_DEPT,
max(sal) over() MAX_SAL,
min(sal) over() MIN_SAL,
round(avg(sal) over()) AVG_SAL,
count(empno) over() COUNT_ALL
FROM EMP e)a;




/*

2. �Ʒ��� ���� EMP Table�� ����Ͽ� �μ��� 
SAL,HIREDATE �� Numbering, ���� 
SAL�� Analytic Function�� ����Ͽ� ���Ͻÿ�. 
*/
SELECT empno,ename,DEPTNO,SAL,hiredate,NUM_sal,CUMM_SAL
from
(select e.*,
sum(sal) over(partition by deptno order by sal, hiredate) CUMM_SAL,
count(empno)over(partition by deptno order by sal, hiredate) NUM_sal
FROM EMP e)
;



/*
3. �Ʒ��� ���� 2�� SQL�� �����Ͽ� �μ����� 
SAL,HIREDATE ������ ENAME�� �����ϴ� SQL�� �ۼ��Ͻÿ�.
*/

select deptno,
max(decode(num_sal,1,ename,null)) as ename_1,
max(decode(num_sal,2,ename,null)) as ename_2,
max(decode(num_sal,3,ename,null)) as ename_3,
max(decode(num_sal,4,ename,null)) as ename_4,
max(decode(num_sal,5,ename,null)) as ename_5,
max(decode(num_sal,6,ename,null)) as ename_6
from
(select e.*,
count(empno)over(partition by e.deptno order by sal, hiredate) NUM_sal
FROM EMP e) a
group by deptno
order by deptno;

select * from emp;

