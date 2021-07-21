/*
3. �Ʒ��� ���� emp table�� �����Ͽ� �μ���,�Ⱓ�� �Ҽӵ� �������� ���ϴ� sql�� �ۼ��Ͻÿ�.
*/
select deptno,to_char(hiredate,'yyyy-mm-dd' ) as start_date,
to_char(
        decode(
                lead(hiredate) over(partition by deptno order by hiredate)
                , null
                , sysdate
                ,lead(hiredate-1) over(partition by deptno order by hiredate)
                )
         ,'yyyy-mm-dd') as end_date,
count(*) over(partition by deptno order by hiredate) as "COUNT(*)"
from emp;
