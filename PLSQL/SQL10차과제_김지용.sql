create or replace procedure restore_sql_procedure
(
f_user varchar2,  -- user 로 부터 입력받을 유저이름
f_tabname varchar2 -- user 로 부터 입력받을 테이블이름
    
)
is
    
    --TABLE 관련변수
    type v_temp_tab is table of sys.dba_tab_columns%rowtype -- 테이블의 타입을 그대로 복사하여 변수생성
    index by binary_integer;
    
    v_temp v_temp_tab;
    r_notnull varchar(10); -- not null 조건을 확인하는 변수
    r_real_leng varchar(100); -- column의 길이를 위한 변수
    r_column varchar2(1000); -- 한줄로 list하여 출력하기 위한 변수
    i binary_integer := 0; -- count를 위한 변수 
    j binary_integer := 0; -- count를 위한 변수 
    
    --INDEX 관련변수
    type v_temp_col is table of sys.dba_ind_columns%rowtype
    index by binary_integer; --테이블 타입 선언
    v_column varchar2(1000); -- 한줄로 list하여 출력하기 위한 변수
    v_temp2 v_temp_col; -- column_name을 저장할 변수
    
    not_result exception; -- 사용자 정의 exception 
    
    

begin
    select NVL(max(line),0)-- 지금까지 입력된 LINE의 가장 큰값입력 null이면 0으로 시작
    into i
    from ddl_scripts  ; 
    

    
    --CREATE TABLE 입력
    i := i+1;
    insert into ddl_scripts (owner, object_type, object_name,line,text)
        values (f_user, 'TABLE',f_tabname, i,'CREATE TABLE'||' '||f_user||'.'||f_tabname);
    --괄호 입력
    i := i+1;
    insert into ddl_scripts (owner, object_type, object_name,line,text)
        values (f_user, 'TABLE',f_tabname, i,'(');    
        
        --1부터 행의 개수만큼 반복문을 돌린다.
    for tab_list in 
        (
            select *
            from sys.dba_tab_columns a   
            where a.owner = f_user
            and a.table_name = f_tabname
            order by column_id
        )loop
            i := i+1;
            
            v_temp(i).column_name := tab_list.column_name;
            v_temp(i).data_type := tab_list.data_type;
            v_temp(i).data_length := tab_list.data_length;
            v_temp(i).data_precision := tab_list.data_precision;
            v_temp(i).data_scale := tab_list.data_scale;
            v_temp(i).nullable := tab_list.nullable;
            v_temp(i).column_id := tab_list.column_id;
            if v_temp(i).nullable = 'N' then
                r_notnull := 'not null';
            else
                r_notnull := '';
            end if; 
            --null인지 아닌지 체크
            
            if v_temp(i).data_precision is not null then
                r_real_leng := v_temp(i).data_precision ;
            else
                r_real_leng := v_temp(i).data_length;
            end if; 
            --datatype에 따라 다른값을 출력해야함으로 precision이 null인지 확인
              
            if (v_temp(i).data_scale is not null) and (v_temp(i).data_scale > 0) then
                r_real_leng := r_real_leng||','||v_temp(i).data_scale;
            else
                r_real_leng := r_real_leng||'';
            end if; 
            --v_temp_scale이 null인지 확인하면서, 0보다 큰지 체크
            
            r_real_leng := '('||r_real_leng||')';
            --형식에 맞게 수정      
            if v_temp(i).data_type = 'DATE' then
             r_real_leng :='';
             end if;
             
             --date 타입일 경우 출력안함
            r_column := v_temp(i).column_name
                ||' '
                ||v_temp(i).data_type
                ||' '
                ||r_real_leng
                ||' '
                ||r_notnull||',';
            
            

            insert into ddl_scripts (owner, object_type, object_name,line,text)
            values (f_user, 'TABLE',f_tabname, i,'    '||r_column);
            
    end loop;
    -- 마지막 컬럼 뒤에 ,를 짜르기 위한 update문
    update ddl_scripts set text = ' '||rtrim(r_column,',') where line= i ;

    --괄호입력
    i := i+1;
    insert into ddl_scripts (owner, object_type, object_name,line,text)
        values (f_user, 'TABLE',f_tabname, i,')');
    --문장입력
    i := i+1;
    insert into ddl_scripts (owner, object_type, object_name,line,text)
        values (f_user, 'TABLE',f_tabname, i,'TABLESPACE USERS;');
    --1차 커밋
    commit;
    --이후로는 INDEX 문장 입력
    for ind_list in 
        (
            select distinct INDEX_NAME
            from sys.dba_ind_columns    
            where table_owner = f_user
            and table_name=f_tabname
        )loop
            v_column :='';
    
    
 
            --CREATE INDEX 입력
            i := i+1;
            insert into ddl_scripts (owner, object_type, object_name,line,text)
                values (f_user, 'INDEX',f_tabname, i,'CREATE INDEX'||' '||f_user||'.'||ind_list.INDEX_NAME);
            
            --인덱스 owner 입력
            i := i+1;
            insert into ddl_scripts (owner, object_type, object_name,line,text)
                values (f_user, 'INDEX',f_tabname, i,'ON'||' '||f_user||'.'||f_tabname);
                
                for col_list in  --반복문
                (
                    select a.COLUMN_NAME
                    from sys.dba_ind_columns a   
                    WHERE a.TABLE_OWNER = f_user
                    and a.index_name = ind_list.INDEX_NAME
                    order by COLUMN_POSITION
                )
                loop
                    --list로 차곡차곡저장
                    v_column := v_column
                        ||col_list.COLUMN_NAME
                        ||',';
                
                end loop;
                v_column := rtrim(v_column,',');
                
            --괄호 입력
            i := i+1;
            insert into ddl_scripts (owner, object_type, object_name,line,text)
                values (f_user, 'INDEX',f_tabname, i,'('||v_column||')');
            --문장입력
            i := i+1;
            insert into ddl_scripts (owner, object_type, object_name,line,text)
                values (f_user, 'INDEX',f_tabname, i,'TABLESPACE USERS;');
              
   
    end loop;
    
     --2차 커밋
    commit;




end restore_sql_procedure; 