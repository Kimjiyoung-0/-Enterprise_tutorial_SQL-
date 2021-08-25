create user test1 identified by oracle;

grant connect, resource to test1;

alter user test1 default tablespace users quota unlimited on users;

-- system�������� ���� synonym�� �����.
--
CREATE OR REPLACE PUBLIC SYNONYM syn_tab_columns FOR dba_tab_columns; -- ���̺� ��ȸ�� ���� �ó��
CREATE OR REPLACE PUBLIC SYNONYM syn_source      FOR dba_source; -- ���, ���ν���, ��Ű�� ��ȸ�� ���� �ó��
CREATE OR REPLACE PUBLIC SYNONYM syn_ind_columns FOR dba_ind_columns ; -- �ε��� ��ȸ�� ���� �ó��
CREATE OR REPLACE PUBLIC SYNONYM syn_views       FOR dba_views; -- �� ��ȸ�� ���� �ó��
CREATE OR REPLACE PUBLIC SYNONYM syn_sequences   FOR dba_sequences; -- ������ ��ȸ�� ���� �ó��
CREATE OR REPLACE PUBLIC SYNONYM syn_synonyms    FOR dba_synonyms; --�ó�� ��ȸ�� ���� �ó��

-- �״��� select������ �ο��ؼ� �ٸ������� select�� �� �ֵ��� ��ġ�Ѵ�.
--�̶� select������ ���̺� , �ó�� �ι��� ����Ѵ�.

--�ó�� select ���� �ο� 
GRANT SELECT ON syn_tab_columns TO  test1;
GRANT SELECT ON syn_source      TO  test1;
GRANT SELECT ON syn_ind_columns TO  test1;
GRANT SELECT ON syn_views       TO  test1;
GRANT SELECT ON syn_sequences   TO  test1;
GRANT SELECT ON syn_synonyms    TO  test1;
--���̺� select ���� �ο� 
GRANT SELECT ON dba_tab_columns TO  test1;
GRANT SELECT ON dba_source      TO  test1;
GRANT SELECT ON dba_ind_columns TO  test1;
GRANT SELECT ON dba_views       TO  test1;
GRANT SELECT ON dba_sequences   TO  test1;
GRANT SELECT ON dba_synonyms    TO  test1;

--�� ������ ��Ű���� �����Ѵ�.
--
--��Ű�� ���ν��� ���� �κ�

EXEC ddl_get_pkg.tab_proc   ('HR','EMP');--table

EXEC ddl_get_pkg.ind_proc   ('HR','EMP');--index

EXEC ddl_get_pkg.view_proc  ('HR','EMP_DETAILS_VIEW');--view

EXEC ddl_get_pkg.seq_proc   ('HR','DEPARTMENTS_SEQ');--seq

EXEC ddl_get_pkg.source_proc('HR','INDEX_COLUMN_FUNCTION');--function

EXEC ddl_get_pkg.source_proc('HR','DML_LOGS');--tri

EXEC ddl_get_pkg.source_proc('HR','RESTORE_SQL_PROCEDURE');--proc

EXEC ddl_get_pkg.source_proc('SYS','DDL_GET_PKG');--package

EXEC ddl_get_pkg.syn_proc   ('SYS','SYN_SYNONYMS');--synonym

--����� ��ȸ
select * from ddl_scripts
order by object_type,OBJECT_NAME,LINE ;
--����� 
delete  from ddl_scripts;
commit;


--�Ϸ� ���
--table 
--index 
--view 
--SEQUENCE

--PACKAGE BODY 
--TYPE BODY 
--TRIGGER
--PACKAGE 
--PROCEDURE 
--LIBRARY 
--FUNCTION 
--TYPE 