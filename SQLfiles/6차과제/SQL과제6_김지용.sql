/*
1. 아래와 같이 각 empno 당 2개씩 row가 생성되도록 만든 후 각 empno 당 1건만 남기고 삭제시키는 문을 작성하시요.  
(최소 2개 이상);

create table emp_dup
as
select a.*
from emp a,
     (select 1 from emp where rownum <= 2) b;
*/
select rownum,emp_dup.* from emp_dup;
select * from emp;
rollback;
/*1.1번 방법 각 컬럼의 고유 id인 rowid를 사용
나중에 들어온 데이터를 삭제*/
delete from emp_dup a
     where rowid > (
                    select min(rowid) 
                    from emp_dup b
                    where b.empno = a.empno
                    );
                    
                    
/*1.2번 rownumber() 를 사용하여 값을 부여하여 delete*/
delete from emp_dup
where 
rowid in (
        select rowid 
        from (
                select * from (
                        select row_number() over(partition by empno order by empno) as empnum
                        from emp_dup
                )
                where empnum > 1 
             )           
);

/*
2. 아래와 같이 sal_hist table을 생성한 후  아래와 같이 기간이 조회되도록 하시요. ;
 
create table sal_hist 
(
	empno      number (4) not null,
	start_yymm char(6),
	sal        number (7,2)
);

insert into sal_hist values (1,'201501',1000);
insert into sal_hist values (1,'201610',1500);
insert into sal_hist values (1,'201801',1700);
insert into sal_hist values (2,'201901',1700);
insert into sal_hist values (3,'201710',1900);
insert into sal_hist values (3,'201901',1700);
commit;
*/
/*테이블에 end_yymm 컬럼추가*/
select empno, start_yymm,
decode(
        to_char(add_months(to_date(lead(start_yymm) over(partition by empno order by empno ),'yyyymm'),-1),'yyyymm')
        , null 
        ,'999912' 
        , to_char(add_months(to_date(lead(start_yymm) over(partition by empno order by empno ),'yyyymm'),-1),'yyyymm')
)as end_yymm
, sal
from sal_hist
order by empno;

/*
3. 아래와 같이 emp table을 참조하여 부서별,기간별 소속된 직원수를 구하는 sql을 작성하시요.
*/
select deptno,to_char(hiredate,'yyyy-mm-dd' ) as start_date,
to_char(
        decode(
                lead(hiredate) over(partition by deptno order by hiredate)
                , null
                , sysdate
                ,lead(hiredate) over(partition by deptno order by hiredate)
                )
         ,'yyyy-mm-dd') as end_date,
         count(*) over(partition by deptno order by hiredate )
from emp;



