/*
1. �Ʒ��� ���� Table ����,Data�� �Է��� �� ������ ���� SQL�� �ּ� ���� 3���� �ۼ��Ͻÿ�!!!!
*/

drop table cust_status;
create table cust_status
 (cust_id      char(1)      not null,
  cust_id_seq  number       not null,
  status       varchar2(10) not null)
 ;
insert into cust_status values ('A',1,'����');
insert into cust_status values ('A',2,'����');
insert into cust_status values ('B',1,'����');
insert into cust_status values ('B',2,'����');
insert into cust_status values ('C',1,'����');
insert into cust_status values ('C',2,'����');
insert into cust_status values ('D',1,'����');
insert into cust_status values ('D',2,'����');
insert into cust_status values ('D',3,'����');
insert into cust_status values ('E',1,'����');
commit;

select * from cust_status;

/*
Q1>  cust_id ���� status ����  �� ������ ����  cust_id �� ���
Q2>  cust_id ���� status ����  �� ������ ����  Row ��ü�� ���
*/
/*1-Q1-1 count�� �ذ� */
select distinct cust_id
from (
        select count(*) over(partition by cust_id,status) cnt_a
        ,count(*) over(partition by cust_id)cnt_b
        ,cust.*
        from cust_status cust
      )
where cnt_a=cnt_b;
/*1-Q2-1 count�� �ذ� */
select cust_id,CUST_ID_SEQ,STATUS
from (
        select count(*) over(partition by cust_id,status) cnt_a
        ,count(*) over(partition by cust_id)cnt_b
        ,cust_status.*
        from cust_status
     )
where cnt_a=cnt_b;
/*1-Q1-2 ROW_NUMBER()�� max�� �ذ� */
select distinct a_max.id as cust_id
from (
        select max(cnt) OVER(PARTITION BY cust_id,status order by cust_id) as max_cnt
        ,max(cnt2) OVER(PARTITION BY cust_id order by cust_id) as max_cnt2
        ,cust_id as id
        ,cust_id_seq
        ,status
        from 
                (
                select ROW_NUMBER() OVER(PARTITION BY cust_id,status order by cust_id) as cnt
                ,ROW_NUMBER() OVER(PARTITION BY cust_id order by cust_id) as cnt2
                ,cust_id
                ,cust_id_seq
                ,status
                from cust_status
                )
      ) a_max
      where a_max.max_cnt = a_max.max_cnt2 ;    
/*1-Q2-2 ROW_NUMBER()�� max�� �ذ� */     
select a_max.id as cust_id, cust_id_seq, status
from (
        select max(cnt) OVER(PARTITION BY cust_id,status order by cust_id) as max_cnt
        ,max(cnt2) OVER(PARTITION BY cust_id order by cust_id) as max_cnt2
        ,cust_id as id
        ,cust_id_seq
        ,status
        from 
                (
                select ROW_NUMBER() OVER(PARTITION BY cust_id,status order by cust_id) as cnt
                ,ROW_NUMBER() OVER(PARTITION BY cust_id order by cust_id) as cnt2
                ,cust_id
                ,cust_id_seq
                ,status
                from cust_status
                )
      ) a_max
      where a_max.max_cnt = a_max.max_cnt2 ;     
/*1-Q1-3 �ϳ��� ���� ���� ������ �ִ� ���̵� ����*/
select distinct cust.cust_id
from 
(
select cust_id id,min(status) mi ,max(status) ma from 
cust_status 
group by cust_id
)minmax
, cust_status cust
where cust.CUST_ID = minmax.id
and minmax.mi = minmax.ma;



/*1-Q2-3 ���� �Ǵ� ������� ���� ������ �ִ� ���̵� ����*/
select distinct cust.*
from 
(
select cust_id id,min(status) mi ,max(status) ma from 
cust_status 
group by cust_id
)minmax
, cust_status cust
where cust.CUST_ID = minmax.id
and minmax.mi = minmax.ma;

/*
2. �Ʒ��� ���� Table�� ���� 
,Data�� �Է��� �� 20190101~20191231���� 
�� 365�� �� ��ȸ�ǵ��� ���ں����踦 ���Ͻÿ�.
*/
drop table repay_test;
create table repay_test 
(
  repay_date varchar2(8)  not null,
  detr_nm    varchar2(10)  not null,
  rbno       varchar2(15) not null,
  loan_bal_amt number not null
  );
insert into repay_test values ('20190103','ȫ�浿','1234567-1234567',1500000);
insert into repay_test values ('20190906','ȫ�浿','1234567-1234567',1000000);  
insert into repay_test values ('20190909','ȫ�浿','1234567-1234567', 500000);
commit;
select * from repay_test;


/**/
select to_date('20190101','yyyymmdd') +level
from dual
connect by level <365;

select  decode(lag(repay_date) over(order by repay_date),null,'20190101',lag(repay_date) over(order by repay_date)) as before_date
        ,repay_date
        ,decode(lead(repay_date) over(order by repay_date),null,'20191231',lead(repay_date) over(order by repay_date))as after_date
        ,detr_nm,rbno,loan_bal_amt
from repay_test re;






select distinct today as tot_date ,REPAY_DATE,DETR_NM,RBNO,
case when today < to_date(REPAY_DATE,'yyyymmdd') then 0
     when today >= to_date(REPAY_DATE,'yyyymmdd')  then LOAN_BAL_AMT 
     end as LOAN_BAL_AMT    
from 
    (
    select to_date('20190101','yyyymmdd') +level-1 as today
    from dual
    connect by level <(to_date('20191231','yyyymmdd')+1) -(to_date('20190101','yyyymmdd')-1)
    )
natural join
    (
    select  
    decode(
        lag(repay_date) over(order by repay_date)
        ,null
        ,'20190101'
        ,lag(repay_date) over(order by repay_date)
    ) as before_date
    ,repay_date
    ,decode(
        lead(repay_date-1) over(order by repay_date)
        ,null
        ,'20191231'
        ,lead(repay_date-1) over(order by repay_date)
     )as after_date
    ,detr_nm,rbno, LOAN_BAL_AMT
    from repay_test
    )re 
where
    (
    today 
    Between to_date(repay_date,'yyyymmdd')
    and to_date(after_date,'yyyymmdd')
    )
    or
    (
    today 
    Between to_date(before_date,'yyyymmdd')
    and to_date(repay_date,'yyyymmdd')
    and before_date = '20190101'
    )
order by today;
 


