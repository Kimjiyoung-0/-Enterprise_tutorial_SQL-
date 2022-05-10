select * from scott.janghak;
select * from scott.student;




--group by 만  사용하여 해결
select entry.j_JUMIN_NO,
       entry.j_YEAR,
       entry.j_HAKGI,
       entry.s_HAKBUN ,
       entry.s_name ,
       entry.s_IPHAK_YMD ,
       entry.s_ADDRESS
  from (select j.JUMIN_NO as j_JUMIN_NO,
               j.YEAR as j_YEAR,
               j.HAKGI as j_HAKGI,
               s.HAKBUN as s_HAKBUN ,
               s.name as s_name ,
               s.IPHAK_YMD as s_IPHAK_YMD ,
               s.ADDRESS as s_ADDRESS ,
               decode( j.hakgi, 1, to_date(j.year||'0302', 'YYYYMMDD') , 2, to_date(j.year||'0902', 'YYYYMMDD') ) hakgi_start,
               decode( j.hakgi, 1, to_date(j.year||'0302', 'YYYYMMDD') , 2, to_date(j.year||'0902', 'YYYYMMDD') ) - to_date(s.IPHAK_YMD, 'YYYYMMDD') chaei
          from janghak j,
               student s )entry ,
       (select j_JUMIN_NO,
               HAKGI_START,
               min(chaei) as min_chaei
          from (select j.JUMIN_NO as j_JUMIN_NO,
                       decode( j.hakgi, 1, to_date(j.year||'0302', 'YYYYMMDD') , 2, to_date(j.year||'0902', 'YYYYMMDD') ) as hakgi_start,
                       decode( j.hakgi, 1, to_date(j.year||'0302', 'YYYYMMDD') , 2, to_date(j.year||'0902', 'YYYYMMDD') ) - to_date(s.IPHAK_YMD, 'YYYYMMDD') as chaei
                  from janghak j,
                       student s
                 where to_date(IPHAK_YMD, 'YYYYMMDD')<decode( j.hakgi, 1, to_date(j.year||'0302', 'YYYYMMDD') , 2, to_date(j.year||'0902', 'YYYYMMDD') )
                 and j.JUMIN_NO=s.JUMIN_NO )
         group by j_JUMIN_NO,
               HAKGI_START ) cal
 where cal.hakgi_start=entry.hakgi_start
   and cal.min_chaei=entry.chaei
   and cal.j_JUMIN_NO=entry.j_JUMIN_NO;
   
   
------ROW_NUMBER() 함수 사용하여 해결
select J_YEAR,J_HAKGI,J_JUMIN_NO,S_HAKBUN,S_NAME,S_IPHAK_YMD,S_ADDRESS
from (
    select cal.*,
    ROW_NUMBER() OVER(PARTITION BY j_JUMIN_NO, hakgi_start
    order by chaei) as num
    from (
        select j.JUMIN_NO as j_JUMIN_NO,
        j.YEAR as j_YEAR,
        j.HAKGI as j_HAKGI,
        j.AMT as j_AMT,
        decode( j.hakgi, 1, to_date(j.year||'0302', 'YYYYMMDD') , 2, to_date(j.year||'0902', 'YYYYMMDD') ) hakgi_start,
        s.HAKBUN as s_HAKBUN,
        s.NAME as s_NAME,
        s.JUMIN_NO as s_JUMIN_NO,
        s.IPHAK_YMD as s_IPHAK_YMD,
        s.ADDRESS as s_ADDRESS,
        decode( j.hakgi, 1, to_date(j.year||'0302', 'YYYYMMDD') , 2, to_date(j.year||'0902', 'YYYYMMDD') ) - to_date(s.IPHAK_YMD, 'YYYYMMDD') chaei
        from scott.janghak j ,
        scott.student s 
        ) cal
    where chaei > 0
    ) 
    where NUM=1;
--(년도,학기,주민번호,학번,이름,입학년월일,주소)
--해석하면 주민번호가 같은 동일인이 입학하고 퇴학하는 절차를 거쳤다.


--로또
create or replace function return_lloto
    return varchar
is
    v_val  varchar(100);
    type v_table  is table of varchar(100)
    index by binary_integer;
    
    v_result v_table;
    v_result1 varchar(100);
    v_result2 varchar(100);
    v_result3 varchar(100);
    v_result4 varchar(100);
    v_result5 varchar(100);
    i binary_integer := 0 ;

begin
    for i in 1..5 loop
    
    select LISTAGG( val, ',')WITHIN GROUP(ORDER BY val)||',+'||CEIL(DBMS_RANDOM.VALUE(0, 45))  into v_val
    from
    (
        SELECT 
        CEIL(DBMS_RANDOM.VALUE(0, 45)) as val
        FROM DUAL
        CONNECT BY LEVEL <= 6
        order by val
    );
    v_result(i) := v_val;
    
    end loop;     

    v_result1 := v_result(1);
    v_result2 := v_result(2);
    v_result3 := v_result(3);
    v_result4 := v_result(4);
    v_result5 := v_result(5);
    return v_result1;
exception

    when others then

        dbms_output.put_line('exception occurred! (' || sqlcode || ') : ' || sqlerrm);

        return '';

end;
/
select return_lloto()
from dual;

;
