/*
1. �Ʒ��� ���� �� empno �� 2���� row�� �����ǵ��� ���� �� �� empno �� 1�Ǹ� ����� ������Ű�� ���� �ۼ��Ͻÿ�.  
(�ּ� 2�� �̻�);

create table emp_dup
as
select a.*
from emp a,
     (select 1 from emp where rownum <= 2) b;
*/
select rownum,emp_dup.* from emp_dup;
select * from emp;
rollback;
/*1.1�� ��� �� �÷��� ���� id�� rowid�� ���
���߿� ���� �����͸� ����*/
delete from emp_dup a
     where rowid > (
                    select min(rowid) 
                    from emp_dup b
                    where b.empno = a.empno
                    );
                    
                    
/*1.2�� rownumber() �� ����Ͽ� ���� �ο��Ͽ� delete*/
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
2. �Ʒ��� ���� sal_hist table�� ������ ��  �Ʒ��� ���� �Ⱓ�� ��ȸ�ǵ��� �Ͻÿ�. ;
 
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
/*���̺� end_yymm �÷��߰�*/
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
3. �Ʒ��� ���� emp table�� �����Ͽ� �μ���,�Ⱓ�� �Ҽӵ� �������� ���ϴ� sql�� �ۼ��Ͻÿ�.
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



