/*
1. 아래와 같이 Table 생성,Data를 입력한 후 질문에 대한 SQL을 최소 각각 3개씩 작성하시요!!!!
*/

drop table cust_status;
create table cust_status
 (cust_id      char(1)      not null,
  cust_id_seq  number       not null,
  status       varchar2(10) not null)
 ;
insert into cust_status values ('A',1,'정상');
insert into cust_status values ('A',2,'위험');
insert into cust_status values ('B',1,'정상');
insert into cust_status values ('B',2,'정상');
insert into cust_status values ('C',1,'위험');
insert into cust_status values ('C',2,'위험');
insert into cust_status values ('D',1,'위험');
insert into cust_status values ('D',2,'위험');
insert into cust_status values ('D',3,'정상');
insert into cust_status values ('E',1,'정상');
commit;

select * from cust_status;

/*
Q1>  cust_id 별로 status 값이  한 종류만 가진  cust_id 만 출력
Q2>  cust_id 별로 status 값이  한 종류만 가진  Row 전체를 출력
*/
/*1-Q1-1 count로 해결 */
select distinct cust_id
from (
        select count(*) over(partition by cust_id,status) cnt_a
        ,count(*) over(partition by cust_id)cnt_b
        ,cust.*
        from cust_status cust
      )
where cnt_a=cnt_b;
/*1-Q2-1 count로 해결 */
select cust_id,CUST_ID_SEQ,STATUS
from (
        select count(*) over(partition by cust_id,status) cnt_a
        ,count(*) over(partition by cust_id)cnt_b
        ,cust_status.*
        from cust_status
     )
where cnt_a=cnt_b;
/*1-Q1-2 ROW_NUMBER()와 max로 해결 */
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
/*1-Q2-2 ROW_NUMBER()와 max로 해결 */     
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
/*1-Q1-3 정상 또는 위험상태 만을 가지고 있는 아이디만 추출*/
select distinct cust_id
from cust_status
where
cust_id not in(
    select cust_id
    from cust_status 
    where status = '정상'
    group by cust_id
)
or
cust_id not in(
    select cust_id 
    from cust_status 
    where status = '위험'
    group by cust_id
);
/*1-Q2-3 정상 또는 위험상태 만을 가지고 있는 아이디만 추출*/
select *
from cust_status
where
cust_id not in(
    select cust_id
    from cust_status 
    where status = '정상'
    group by cust_id
)
or
cust_id not in(
    select cust_id 
    from cust_status 
    where status = '위험'
    group by cust_id
);

/*
2. 아래와 같은 Table을 생성 
,Data를 입력한 후 20190101~20191231까지 
총 365건 이 조회되도록 일자별집계를 구하시요.
*/
drop table repay_test;
create table repay_test 
(
  repay_date varchar2(8)  not null,
  detr_nm    varchar2(10)  not null,
  rbno       varchar2(15) not null,
  loan_bal_amt number not null
  );
insert into repay_test values ('20190103','홍길동','1234567-1234567',1500000);
insert into repay_test values ('20190906','홍길동','1234567-1234567',1000000);  
insert into repay_test values ('20190909','홍길동','1234567-1234567', 500000);
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
    select to_date('20181231','yyyymmdd') +level as today
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
 


