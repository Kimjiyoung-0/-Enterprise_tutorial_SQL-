select s_id,s_nm,c_id,c_nm,max("1cha") as "1��",max("2cha") as "2��",max("3cha") as "3��",count(chasu) as "����Ƚ��"
from(
    select 
        s.*, 
        c.*, 
        decode(chasu,1,'O',null) as "1cha",
        decode(chasu,2,'O',null) as "2cha",
        decode(chasu,3,'O',null) as "3cha",
        chasu
    from student s , course c , study st
    where s.s_id = st.s_id(+) -- ��������� 0�̾ �������ϴ� study�� �������� outer join 
    and c.c_id = st.c_id(+)
)
group by s_id,s_nm,c_id,c_nm
order by s_id,c_id;


