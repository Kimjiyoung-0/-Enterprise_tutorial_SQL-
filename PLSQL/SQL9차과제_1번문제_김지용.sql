CREATE OR REPLACE FUNCTION index_column_function(f_user varchar2,f_empname varchar2)
    RETURN VARCHAR2 
IS
   v_temp VARCHAR2(1000); -- column_name�� ������ ����
   v_column VARCHAR2(1000); -- column_name�� list�� ������ ����
   v_cnt number;
BEGIN
    --���� ���� üũ
    SELECT max(rownum)
    into v_cnt
    FROM all_ind_columns a  
    WHERE a.TABLE_OWNER = f_user
    and a.index_name = f_empname;
    
    
    --���� ������ŭ �ݺ�
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
        --list�� ������������
        v_column := v_column
            ||v_temp
            ||',';
    end loop;
    --�� ������ �ڸ���
    v_column := rtrim(v_column,',');
    RETURN v_column;     

END;