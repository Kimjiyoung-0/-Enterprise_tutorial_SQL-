create or replace function index_column_function(f_user varchar2,f_empname varchar2)
    return varchar2 
is
    type v_temp_col is table of sys.dba_ind_columns%rowtype
    index by binary_integer; --테이블 타입 선언
    
    v_temp v_temp_col; -- column_name을 저장할 변수
    v_column varchar2(1000); -- column_name을 list로 저장할 변수
    i binary_integer := 0; -- count를 위한 변수
    
    not_result exception; -- 사용자 정의 exception 
begin
    
    for ind_list in  --반복문
    (
        select a.COLUMN_NAME
        from sys.dba_ind_columns a   
        WHERE a.TABLE_OWNER = f_user
        and a.index_name = f_empname
        order by COLUMN_POSITION
    )
    loop
    
        i:=i+1;
        v_temp(i).COLUMN_NAME := ind_list.COLUMN_NAME;
        
        --list로 차곡차곡저장
        v_column := v_column
            ||v_temp(i).COLUMN_NAME
            ||',';
    
    end loop;
    --맨 오른쪽 자르기
    v_column := rtrim(v_column,',');
    if trim(v_column) is null then
            raise not_result;
    end if;
    return v_column; 
    
    exception
    when no_data_found then --데이터가 없을때
        RAISE_APPLICATION_ERROR(-21001,'no_data_found');
    when value_error then --값을 잘못입력 했을때
        RAISE_APPLICATION_ERROR(-21002,'value_error');
    when not_result then 
        RAISE_APPLICATION_ERROR(-20999,'데이터가 검색되지 않습니다. 유저명과 테이블 이름을 확인해 주십시오.');
    when others then --그외
        RAISE_APPLICATION_ERROR(-21000,'others error');
end;    