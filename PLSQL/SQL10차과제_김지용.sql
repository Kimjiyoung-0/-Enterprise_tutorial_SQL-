create or replace procedure restore_sql_procedure
(
f_user varchar2,  -- user �� ���� �Է¹��� �����̸�
f_tabname varchar2 -- user �� ���� �Է¹��� ���̺��̸�
    
)
is
    
    --TABLE ���ú���
    type v_temp_tab is table of sys.dba_tab_columns%rowtype -- ���̺��� Ÿ���� �״�� �����Ͽ� ��������
    index by binary_integer;
    
    v_temp v_temp_tab;
    r_notnull varchar(10); -- not null ������ Ȯ���ϴ� ����
    r_real_leng varchar(100); -- column�� ���̸� ���� ����
    r_column varchar2(1000); -- ���ٷ� list�Ͽ� ����ϱ� ���� ����
    i binary_integer := 0; -- count�� ���� ���� 
    j binary_integer := 0; -- count�� ���� ���� 
    
    --INDEX ���ú���
    type v_temp_col is table of sys.dba_ind_columns%rowtype
    index by binary_integer; --���̺� Ÿ�� ����
    v_column varchar2(1000); -- ���ٷ� list�Ͽ� ����ϱ� ���� ����
    v_temp2 v_temp_col; -- column_name�� ������ ����
    
    not_result exception; -- ����� ���� exception 
    
    

begin
    select NVL(max(line),0)-- ���ݱ��� �Էµ� LINE�� ���� ū���Է� null�̸� 0���� ����
    into i
    from ddl_scripts  ; 
    

    
    --CREATE TABLE �Է�
    i := i+1;
    insert into ddl_scripts (owner, object_type, object_name,line,text)
        values (f_user, 'TABLE',f_tabname, i,'CREATE TABLE'||' '||f_user||'.'||f_tabname);
    --��ȣ �Է�
    i := i+1;
    insert into ddl_scripts (owner, object_type, object_name,line,text)
        values (f_user, 'TABLE',f_tabname, i,'(');    
        
        --1���� ���� ������ŭ �ݺ����� ������.
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
            --null���� �ƴ��� üũ
            
            if v_temp(i).data_precision is not null then
                r_real_leng := v_temp(i).data_precision ;
            else
                r_real_leng := v_temp(i).data_length;
            end if; 
            --datatype�� ���� �ٸ����� ����ؾ������� precision�� null���� Ȯ��
              
            if (v_temp(i).data_scale is not null) and (v_temp(i).data_scale > 0) then
                r_real_leng := r_real_leng||','||v_temp(i).data_scale;
            else
                r_real_leng := r_real_leng||'';
            end if; 
            --v_temp_scale�� null���� Ȯ���ϸ鼭, 0���� ū�� üũ
            
            r_real_leng := '('||r_real_leng||')';
            --���Ŀ� �°� ����      
            if v_temp(i).data_type = 'DATE' then
             r_real_leng :='';
             end if;
             
             --date Ÿ���� ��� ��¾���
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
    -- ������ �÷� �ڿ� ,�� ¥���� ���� update��
    update ddl_scripts set text = ' '||rtrim(r_column,',') where line= i ;

    --��ȣ�Է�
    i := i+1;
    insert into ddl_scripts (owner, object_type, object_name,line,text)
        values (f_user, 'TABLE',f_tabname, i,')');
    --�����Է�
    i := i+1;
    insert into ddl_scripts (owner, object_type, object_name,line,text)
        values (f_user, 'TABLE',f_tabname, i,'TABLESPACE USERS;');
    --1�� Ŀ��
    commit;
    --���ķδ� INDEX ���� �Է�
    for ind_list in 
        (
            select distinct INDEX_NAME
            from sys.dba_ind_columns    
            where table_owner = f_user
            and table_name=f_tabname
        )loop
            v_column :='';
    
    
 
            --CREATE INDEX �Է�
            i := i+1;
            insert into ddl_scripts (owner, object_type, object_name,line,text)
                values (f_user, 'INDEX',f_tabname, i,'CREATE INDEX'||' '||f_user||'.'||ind_list.INDEX_NAME);
            
            --�ε��� owner �Է�
            i := i+1;
            insert into ddl_scripts (owner, object_type, object_name,line,text)
                values (f_user, 'INDEX',f_tabname, i,'ON'||' '||f_user||'.'||f_tabname);
                
                for col_list in  --�ݺ���
                (
                    select a.COLUMN_NAME
                    from sys.dba_ind_columns a   
                    WHERE a.TABLE_OWNER = f_user
                    and a.index_name = ind_list.INDEX_NAME
                    order by COLUMN_POSITION
                )
                loop
                    --list�� ������������
                    v_column := v_column
                        ||col_list.COLUMN_NAME
                        ||',';
                
                end loop;
                v_column := rtrim(v_column,',');
                
            --��ȣ �Է�
            i := i+1;
            insert into ddl_scripts (owner, object_type, object_name,line,text)
                values (f_user, 'INDEX',f_tabname, i,'('||v_column||')');
            --�����Է�
            i := i+1;
            insert into ddl_scripts (owner, object_type, object_name,line,text)
                values (f_user, 'INDEX',f_tabname, i,'TABLESPACE USERS;');
              
   
    end loop;
    
     --2�� Ŀ��
    commit;




end restore_sql_procedure; 