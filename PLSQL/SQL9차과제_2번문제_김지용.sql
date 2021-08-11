create or replace function tab_column_function(f_user varchar2,f_empname varchar2)
    return varchar2
is
   v_temp_name varchar2(100); -- column_name을 저장할 변수
   v_temp_datatype varchar2(100); -- data_type을 저장할 변수
   v_temp_leng number; -- data_length을 저장할 변수
   v_temp_precision number; -- data_precision을 저장할 변수
   v_temp_scale number; -- data_scale을 저장할 변수
   v_temp_notnull varchar2(100); --  nullable을 저장할 변수
   v_temp_real_leng varchar2(100); -- 데이터타입에 따라 다른 깅이를 저장하기 위한 변수
   v_column varchar2(1000); -- 한줄로 list하여 출력하기 위한 변수
   v_cnt number; -- count를 위한 변수 
begin
    --max(rownum)으로 행이 몇개가 있는지 카운트한다.
    select max(rownum)
    into v_cnt
    from all_tab_columns a   
    where a.owner = f_user
    and a.table_name = f_empname;        
    --1부터 행의 개수만큼 반복문을 돌린다.
    
    for i in 1..v_cnt
    loop
        v_temp_real_leng := '';

        select 
            column_name,
            data_type,
            nullable,
            data_length,
            data_precision,
            data_scale
        into 
            v_temp_name,
            v_temp_datatype,
            v_temp_notnull,
            v_temp_leng,
            v_temp_precision,
            v_temp_SCALE
        from
            (
            select a.*,rownum as num
            from all_tab_columns a   
            where a.owner = f_user
            and a.table_name = f_empname
            )
        where num =i;
        --i값으로 행을 구분한다.
        
        if v_temp_notnull = 'N' then
            v_temp_notnull := 'NOT NULL';
        else
            v_temp_notnull := '';
        end if; 
        --null인지 아닌지 체크
        
        if v_temp_precision is not null then
            v_temp_real_leng := v_temp_precision;
        else
            v_temp_real_leng := v_temp_leng;
        end if; 
        --datatype에 따라 다른값을 출력해야함으로 v_temp_precision이 null인지 확인
          
        if (v_temp_SCALE is not null) and (v_temp_SCALE > 0) then
            v_temp_real_leng := v_temp_real_leng||','||v_temp_SCALE;
        else
            v_temp_real_leng := v_temp_real_leng||'';
        end if; 
        --v_temp_SCALE이 null인지 확인하면서, 0보다 큰지 체크
        
        v_temp_real_leng := '('||v_temp_real_leng||')';
        --형식에 맞게 수정
        
        if v_temp_datatype = 'DATE' then
         v_temp_real_leng :='';
         end if;
         --DATE 타입일 경우 출력안함
 
        v_column := v_column 
            ||v_temp_name
            ||' '
            ||v_temp_datatype
            ||' '
            ||v_temp_real_leng
            ||' '
            ||v_temp_notnull||',';
    end loop;

    v_column := rtrim(v_column,',');
    --맨오른쪽에서 , 하나 제거
    return v_column;     
end;