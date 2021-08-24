create or replace package body ddl_get_pkg
IS
--------------------tab ���ν���-----------------------
    procedure tab_proc
    (
        f_user varchar2,  -- user �� ���� �Է¹��� �����̸�
        f_tabname varchar2 -- user �� ���� �Է¹��� ���̺��̸�
    )
    is   
        --TABLE ���ú���
        r_notnull varchar(10); -- not null ������ Ȯ���ϴ� ����
        r_real_leng varchar(100); -- column�� ���̸� ���� ����
        r_column varchar2(1000); -- ���ٷ� list�Ͽ� ����ϱ� ���� ����
        i binary_integer := 0; -- count�� ���� ���� 
        
        not_result exception; -- ����� ���� exception
      
    begin
        select max(COLUMN_NAME) -- ���� �ִ��� Ȯ��
        into r_column
        from syn_tab_columns   --synonnym�� ����Ͽ� �ٸ� ������ ����Ҷ����� ������ �����ʾƵ��ȴ�. 
        where owner = f_user
        and table_name = f_tabname;
      
        if r_column is null then -- ������� �ƹ��͵� ������
            raise not_result; --���� exception ȣ��
        end if;
        r_column := '';
        
        --CREATE TABLE �Է�
        i := 1;
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
                from syn_tab_columns --synonnym�� ����Ͽ� �ٸ� ������ ����Ҷ����� ������ �����ʾƵ��ȴ�. 
                where owner = f_user
                and table_name = f_tabname
                order by column_id
            )loop
                i := i+1;
                
                if tab_list.nullable = 'N' then
                    r_notnull := 'not null';
                else
                    r_notnull := '';
                end if; 
                --null���� �ƴ��� üũ
                
                if tab_list.data_precision is not null then
                    r_real_leng := tab_list.data_precision ;
                else
                    r_real_leng := tab_list.data_length;
                end if; 
                --datatype�� ���� �ٸ����� ����ؾ������� precision�� null���� Ȯ��
                  
                if (tab_list.data_scale is not null) and (tab_list.data_scale > 0) then
                    r_real_leng := r_real_leng||','||tab_list.data_scale;
                else
                    r_real_leng := r_real_leng||'';
                end if; 
                --v_temp_scale�� null���� Ȯ���ϸ鼭, 0���� ū�� üũ
                
                r_real_leng := '('||r_real_leng||')';
                --���Ŀ� �°� ����      
                if tab_list.data_type = 'DATE' then
                    r_real_leng :='';
                end if;
                 
                 --date Ÿ���� ��� ��¾���
                r_column := tab_list.column_name
                    ||' '
                    ||tab_list.data_type
                    ||' '
                    ||r_real_leng
                    ||' '
                    ||r_notnull||',';
                
                insert into ddl_scripts (owner, object_type, object_name,line,text)
                values (f_user, 'TABLE',f_tabname, i,'    '||r_column);
                
        end loop;
        -- ������ �÷� �ڿ� ,�� ¥���� ���� update��
        update ddl_scripts set text = '    '||rtrim(r_column,',') where line= i ;

        --��ȣ�Է�
        i := i+1;
        insert into ddl_scripts (owner, object_type, object_name,line,text)
            values (f_user, 'TABLE',f_tabname, i,')');
        --�����Է�
        i := i+1;
        insert into ddl_scripts (owner, object_type, object_name,line,text)
            values (f_user, 'TABLE',f_tabname, i,'TABLESPACE USERS;');
            
        --Ŀ��
        commit;

        exception
        when no_data_found then --�����Ͱ� ������
            RAISE_APPLICATION_ERROR(-20996,'not_data_found');
        when value_error then --���� �߸��Է� ������
            RAISE_APPLICATION_ERROR(-20997,'value_error');
        when not_result then 
            RAISE_APPLICATION_ERROR(-20999,'�����Ͱ� �˻����� �ʽ��ϴ�. ������� ���̺� �̸��� Ȯ���� �ֽʽÿ�.');
        when others then --�׿�
            RAISE_APPLICATION_ERROR(-20998,'others error');
    end tab_proc; 
--------------------source ���ν���--------------------
    procedure source_proc
    (
        f_user varchar2,  -- user �� ���� �Է¹��� �����̸�
        f_objname varchar2 -- user �� ���� �Է¹��� ������Ʈ�̸�
    )
    is
        --source ���ú���
        v_create varchar2(100); -- CREATE OR REPLACE�� ���� ����
        v_type varchar(100);
        i binary_integer := 0; -- count�� ���� ���� 
        
        not_result exception; -- ����� ���� exception
    
    begin 
        
        select max(name) -- ���� �ִ��� Ȯ��
        into v_create
        from syn_source --synonnym�� ����Ͽ� �ٸ� ������ ����Ҷ����� ������ �����ʾƵ��ȴ�.    
        where owner = f_user
        and name = f_objname;
      
        if v_create is null then -- ������� �ƹ��͵� ������
            raise not_result; --���� exception ȣ��
        end if;
        v_create := '';
        
        --source ���̺� �˻�
        for objlist in
        (
            select *
            from syn_source --synonnym�� ����Ͽ� �ٸ� ������ ����Ҷ����� ������ �����ʾƵ��ȴ�.    
            where owner = f_user
            and name = f_objname  
        )loop
            
            i:= i+1;
            if i=1 or v_type != objlist.type then--ù��° ���̰ų� ������Ʈ Ÿ���� �޶����� 
            
                i:=1;
                v_create := 'CREATE OR REPLACE'; -- �̹����� ������ �ִ´�
                v_type := objlist.type;
            else
                v_create := '';
               
            end if;

            insert into ddl_scripts (owner, object_type, object_name,line,text)
                        values (f_user, objlist.type, f_objname, i,v_create||' '||objlist.text);
        
        end loop;
        

        commit;
        
        exception
        when not_result then 
            RAISE_APPLICATION_ERROR(-20999,'�����Ͱ� �˻����� �ʽ��ϴ�. ������� ������Ʈ �̸��� Ȯ���� �ֽʽÿ�.');
        when no_data_found then --�����Ͱ� ������
            RAISE_APPLICATION_ERROR(-20996,'not_data_found');
        when value_error then --���� �߸��Է� ������
            RAISE_APPLICATION_ERROR(-20997,'value_error');
        when others then --�׿�
            RAISE_APPLICATION_ERROR(-20998,'others error');
    end source_proc;
    
--------------------ind ���ν���-----------------------
    procedure ind_proc
    (
        f_user varchar2,  -- user �� ���� �Է¹��� �����̸�
        f_tabname varchar2 -- user �� ���� �Է¹��� �ε����̸�
    )
    is
        --INDEX ���ú���
        
        i binary_integer := 0; -- count�� ���� ���� 
        
        v_index varchar2(1000):=''; -- ���ٷ� list�Ͽ� ����ϱ� ���� ����
        v_unique varchar(40); -- unique ���θ� ���� ����
        
        not_result exception; -- ����� ���� exception 
        
    begin
        select max(INDEX_NAME) -- ���� �ִ��� Ȯ��
        into v_index
        from syn_ind_columns --synonnym�� ����Ͽ� �ٸ� ������ ����Ҷ����� ������ �����ʾƵ��ȴ�.    
        where table_owner = f_user
        and table_name=f_tabname;
        
        if v_index is null then -- ������� �ƹ��͵� ������
            raise not_result; --���� exception ȣ��
        end if;
        v_index := '';

        --���ķδ� INDEX ���� �Է�
        for ind_list in 
            (
                select distinct INDEX_NAME
                from syn_ind_columns  --synonnym�� ����Ͽ� �ٸ� ������ ����Ҷ����� ������ �����ʾƵ��ȴ�.   
                where table_owner = f_user
                and table_name=f_tabname
            )loop
                select max(decode(CONSTRAINT_TYPE,'P','UNIQUE',null))
                into v_unique
                from all_constraints
                where table_name = f_tabname
                and owner = f_user
                and INDEX_NAME = ind_list.INDEX_NAME;
                
                i:=0;
                
                --CREATE INDEX �Է�
                i := i+1;
                insert into ddl_scripts (owner, object_type, object_name,line,text)
                    values (f_user, 'INDEX',ind_list.INDEX_NAME, i,'CREATE '||v_unique||' INDEX'||' '||f_user||'.'||ind_list.INDEX_NAME);
                
                --�ε��� owner �Է�
                i := i+1;
                insert into ddl_scripts (owner, object_type, object_name,line,text)
                    values (f_user, 'INDEX',ind_list.INDEX_NAME, i,'ON'||' '||f_user||'.'||f_tabname);
                    
                    for col_list in  --�ݺ���
                    (
                        select COLUMN_NAME
                        from syn_ind_columns  --synonnym�� ����Ͽ� �ٸ� ������ ����Ҷ����� ������ �����ʾƵ��ȴ�.  
                        WHERE TABLE_OWNER = f_user
                        and table_name = f_tabname
                        and index_name = ind_list.INDEX_NAME
                        order by COLUMN_POSITION
                    )
                    loop
                        --list�� ������������
                        v_index := v_index||
                            col_list.COLUMN_NAME
                            ||','
                            
                            ;
                            
                    end loop;
                    v_index := rtrim(v_index,',');
                    DBMS_OUTPUT.PUT_LINE( v_index );
                    
                --��ȣ �Է�
                i := i+1;
                insert into ddl_scripts (owner, object_type, object_name,line,text)
                    values (f_user, 'INDEX',ind_list.INDEX_NAME, i,'('||v_index||')');
                v_index := '';
                --�����Է�
                i := i+1;
                insert into ddl_scripts (owner, object_type, object_name,line,text)
                    values (f_user, 'INDEX',ind_list.INDEX_NAME, i,'TABLESPACE USERS;');
                    
        end loop;
        
         --2�� Ŀ��
        commit;
         exception
        when no_data_found then --�����Ͱ� ������
            RAISE_APPLICATION_ERROR(-20996,'not_data_found');
        when value_error then --���� �߸��Է� ������
            RAISE_APPLICATION_ERROR(-20997,'value_error');
        when not_result then 
            RAISE_APPLICATION_ERROR(-20999,'�����Ͱ� �˻����� �ʽ��ϴ�. ������� �ε��� �̸��� Ȯ���� �ֽʽÿ�.');   
        --when others then --�׿�
         --   RAISE_APPLICATION_ERROR(-20998,'others error');
        
    end ind_proc; 
    
    --------------------view ���ν���-----------------------
    procedure view_proc
    (
        f_user varchar2,  -- user �� ���� �Է¹��� �����̸�
        f_viewname varchar2 -- user �� ���� �Է¹��� �ε����̸�
        
    )
    is
        i binary_integer := 0; -- count�� ���� ���� 
        j binary_integer := 0; -- ���ڿ��� ��������  üũ�ϱ� ���� ���� 
        v_text varchar2(100); -- ���ٷ� list�ޱ����� ����
        
        not_result exception; -- ����� ���� exception

    begin
        select max(view_name) -- ���� �ִ��� Ȯ��
        into v_text
        from syn_views  --synonnym�� ����Ͽ� �ٸ� ������ ����Ҷ����� ������ �����ʾƵ��ȴ�.  
        where owner = f_user
        and view_name=f_viewname;
            
        if v_text is null then -- ������� �ƹ��͵� ������
            raise not_result; --���� exception ȣ��
        end if;
        v_text := '';

        for view_list in 
            (
                select *          
                from syn_views --synonnym�� ����Ͽ� �ٸ� ������ ����Ҷ����� ������ �����ʾƵ��ȴ�.    
                where owner = f_user
                and view_name=f_viewname
            )loop           
                i:=0;         
                --CREATE VIEW �Է�
                i := i+1;
                insert into ddl_scripts (owner, object_type, object_name,line,text)
                    values (f_user, 'VIEW',view_list.VIEW_NAME, i,'CREATE OR REPLACE VIEW '||view_list.VIEW_NAME||' AS');
                    --ù���� �Է�
                v_text := substr(view_list.text_vc, 1,INSTR(view_list.text_vc,CHR(10), 1 , 1));  
                    
                i := i+1;
                insert into ddl_scripts (owner, object_type, object_name,line,text)
                    values (f_user, 'VIEW',view_list.VIEW_NAME, i,v_text);
                
                loop
                    i := i+1;
                    v_text := substr(view_list.text_vc,
                    INSTR(view_list.text_vc,CHR(10), 1 , i-2),
                    INSTR(view_list.text_vc,CHR(10), 1 , i-1)-INSTR(view_list.text_vc,CHR(10), 1 , i-2));
                    
                    insert into ddl_scripts (owner, object_type, object_name,line,text)
                    values (f_user, 'VIEW',view_list.VIEW_NAME, i,v_text);
                    
                    
                    j := INSTR(view_list.text_vc,CHR(10), 1 , i-1);
                    
                    exit when j = 0;
                end loop;
                -- ; �Է�
                
            update ddl_scripts 
            set text = text||';' 
            where line = i;     
                    
        end loop;      
        
         --Ŀ��
        commit; 
        exception
        when no_data_found then --�����Ͱ� ������
            RAISE_APPLICATION_ERROR(-20996,'not_data_found');
        when value_error then --���� �߸��Է� ������
            RAISE_APPLICATION_ERROR(-20997,'value_error');
        when not_result then 
            RAISE_APPLICATION_ERROR(-20999,'�����Ͱ� �˻����� �ʽ��ϴ�. ������� �� �̸��� Ȯ���� �ֽʽÿ�.');   
        when others then --�׿�
            RAISE_APPLICATION_ERROR(-20998,'others error');
    end view_proc;
--------------------seq ���ν���-----------------------
procedure seq_proc
    (
        f_user varchar2,  -- user �� ���� �Է¹��� �����̸�
        f_seqname varchar2 -- user �� ���� �Է¹��� �������̸�
    )
        is
        i binary_integer := 0; -- count�� ���� ���� 
        v_text varchar2(100); -- ���ٷ� list�ޱ����� ����
        
        not_result exception; -- ����� ���� exception
      
    begin
        for seq_list in 
        (
                select *          
                from syn_sequences  --synonnym�� ����Ͽ� �ٸ� ������ ����Ҷ����� ������ �����ʾƵ��ȴ�.  
                where sequence_owner = f_user
                and sequence_name=f_seqname
         )loop 
            i:=i+1;
            insert into ddl_scripts (owner, object_type, object_name,line,text)
                values (f_user, 'SEQUENCE',f_seqname, i,'CREATE SEQUENCE '||seq_list.SEQUENCE_NAME);
            i:=i+1;
            insert into ddl_scripts (owner, object_type, object_name,line,text)
                values (f_user, 'SEQUENCE',f_seqname, i,'INCREMENT BY '||seq_list.INCREMENT_BY);
            i:=i+1;
            insert into ddl_scripts (owner, object_type, object_name,line,text)
                values (f_user, 'SEQUENCE',f_seqname, i,'MINVALUE '||seq_list.MIN_VALUE);
            i:=i+1;
            insert into ddl_scripts (owner, object_type, object_name,line,text)
                values (f_user, 'SEQUENCE',f_seqname, i,'MAXVALUE '||seq_list.MAX_VALUE);
                
            if seq_list.cycle_flag = 'N' then
                v_text := 'NOCYCLE';
            else
                v_text := 'CYCLE';
            end if;           
                
            i:=i+1;
            insert into ddl_scripts (owner, object_type, object_name,line,text)
                values (f_user, 'SEQUENCE',f_seqname, i,v_text);
                
            
            
            if seq_list.ORDER_FLAG = 'N' then
                v_text := 'NOORDER';
            else
                v_text := 'ORDER';
            end if;
            
            i:=i+1;
            insert into ddl_scripts (owner, object_type, object_name,line,text)
                values (f_user, 'SEQUENCE',f_seqname, i,v_text);
            
            if seq_list.cache_size != 0 then
            
                i := i+1;
                insert into ddl_scripts (owner, object_type, object_name,line,text)
                    values (f_user, 'SEQUENCE',f_seqname, i,'CACHE '||seq_list.cache_size); 
            end if;
            
            i:=i+1;
            insert into ddl_scripts (owner, object_type, object_name,line,text)
                values (f_user, 'SEQUENCE',f_seqname, i,';');
            
        end loop;
    end seq_proc;
END ddl_get_pkg;