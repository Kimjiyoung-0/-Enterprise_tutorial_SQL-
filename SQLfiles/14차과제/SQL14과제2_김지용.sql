select s_id,s_nm,c_id,c_nm,max("1cha") as "1차",max("2cha") as "2차",max("3cha") as "3차",count(chasu) as "참여횟수"
from(
    select 
        s.*, 
        c.*, 
        decode(chasu,1,'O',null) as "1cha",
        decode(chasu,2,'O',null) as "2cha",
        decode(chasu,3,'O',null) as "3cha",
        chasu
    from student s , course c , study st
    where s.s_id = st.s_id(+) -- 수강기록이 0이어도 뽑혀야하니 study를 기준으로 outer join 
    and c.c_id = st.c_id(+)
)
group by s_id,s_nm,c_id,c_nm
order by s_id,c_id;


