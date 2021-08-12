/*
3. 아래와 같이 emp table을 참조하여 부서별,기간별 소속된 직원수를 구하는 sql을 작성하시요.
*/
select deptno, to_char( hiredate,'yyyy-mm-dd' ) as start_date,
to_char(
        decode(
                lead(hiredate) over(partition by deptno order by hiredate)
                , null
                , sysdate
                ,lead(hiredate-1) over(partition by deptno order by hiredate)
                )
         ,'yyyy-mm-dd') as end_date,
sum(cnt) over(partition by deptno order by hiredate) as "count(*)"
from (
        select ROW_NUMBER() OVER(PARTITION BY hiredate,deptno order by hiredate) as rnum
        ,count(distinct hiredate) over(partition by deptno,hiredate) as cnt
        , emp.*  
        from emp
        )a
where rnum = 1;
