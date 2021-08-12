CREATE OR REPLACE FUNCTION index_column_function(f_user varchar2,f_empname varchar2)
    RETURN VARCHAR2 
IS
   v_temp VARCHAR2(1000); -- column_name을 저장할 변수
   v_column VARCHAR2(1000); -- column_name을 list로 저장할 변수
   v_cnt number;
BEGIN
    --행의 개수 체크
    SELECT max(rownum)
    into v_cnt
    FROM all_ind_columns a  
    WHERE a.TABLE_OWNER = f_user
    and a.index_name = f_empname;
    
    
    --행의 갯수만큼 반복
    for i in 1..v_cnt
    loop

        select column_name
        into v_temp
        from 
            (
            SELECT a.column_name,rownum as num
            FROM all_ind_columns a  
            WHERE a.TABLE_OWNER = f_user
            and a.index_name = f_empname
            )
        where num =i;
        --list로 차곡차곡저장
        v_column := v_column
            ||v_temp
            ||',';
    end loop;
    --맨 오른쪽 자르기
    v_column := rtrim(v_column,',');
    RETURN v_column;     

END;
