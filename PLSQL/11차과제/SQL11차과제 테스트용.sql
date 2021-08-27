--�׽�Ʈ ����  ���� ����
create user test1 identified by oracle;

--�α���, �ڿ� ������ �ο�
grant connect, resource to test1;
--�׽�Ʈ ������ ���̺� �����̽��� �̿��� �� �ְ� �Ҵ�
alter user test1 default tablespace users quota unlimited on users;

-- system�������� ���� synonym�� �����.
--
CREATE OR REPLACE PUBLIC SYNONYM dba_tab_columns_syn    FOR dba_tab_columns; -- ���̺� ��ȸ�� ���� �ó��
CREATE OR REPLACE PUBLIC SYNONYM dba_source_syn         FOR dba_source; -- ���, ���ν���, ��Ű�� ��ȸ�� ���� �ó��
CREATE OR REPLACE PUBLIC SYNONYM dba_ind_columns_syn    FOR dba_ind_columns ; -- �ε��� ��ȸ�� ���� �ó��
CREATE OR REPLACE PUBLIC SYNONYM dba_views_syn          FOR dba_views; -- �� ��ȸ�� ���� �ó��
CREATE OR REPLACE PUBLIC SYNONYM dba_sequences_syn      FOR dba_sequences; -- ������ ��ȸ�� ���� �ó��
CREATE OR REPLACE PUBLIC SYNONYM dba_synonyms_syn       FOR dba_synonyms; --�ó�� ��ȸ�� ���� �ó��

--  �״��� select������ �ο��ؼ� �ٸ������� select�� �� �ֵ��� ��ġ�Ѵ�.
--  �̶� select������ ���̺� , �ó�� �ι��� ����Ѵ�.

--�ó�� select ���� �ο� 
GRANT SELECT ON dba_tab_columns_syn TO  test1;
GRANT SELECT ON dba_source_syn      TO  test1;
GRANT SELECT ON dba_ind_columns_syn TO  test1;
GRANT SELECT ON dba_views_syn       TO  test1;
GRANT SELECT ON dba_sequences_syn   TO  test1;
GRANT SELECT ON dba_synonyms_syn    TO  test1;
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
CREATE SEQUENCE DEPARTMENTS_SEQ INCREMENT BY 10 MINVALUE 1 MAXVALUE 9990 NOCYCLE  NOORDER CACHE 20 ;
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