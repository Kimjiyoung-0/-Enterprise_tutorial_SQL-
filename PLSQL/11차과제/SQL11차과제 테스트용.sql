
-- system�������� ���� synonym�� �����.
--
CREATE OR REPLACE PUBLIC SYNONYM syn_tab_columns FOR dba_tab_columns;
CREATE OR REPLACE PUBLIC SYNONYM syn_source FOR dba_source;
CREATE OR REPLACE PUBLIC SYNONYM syn_ind_columns  FOR dba_ind_columns  ;
CREATE OR REPLACE PUBLIC SYNONYM syn_views FOR dba_views ;
CREATE OR REPLACE PUBLIC SYNONYM syn_sequences FOR dba_sequences ;

-- �״��� select������ public ���� �ٲپ� �ٸ������� select�� �� �ֵ��� ��ġ�Ѵ�.
GRANT SELECT ON syn_tab_columns TO PUBLIC;
GRANT SELECT ON syn_source TO PUBLIC;
GRANT SELECT ON syn_ind_columns TO PUBLIC;
GRANT SELECT ON syn_views TO PUBLIC;
GRANT SELECT ON syn_sequences TO PUBLIC;
--Ŀ��
commit;
--�� ������ ��Ű���� �����Ѵ�.
--
--��Ű�� ���ν��� ���� �κ�

EXEC ddl_get_pkg.tab_proc('HR','EMP');--table

EXEC ddl_get_pkg.ind_proc('HR','EMP');--index

EXEC ddl_get_pkg.view_proc('HR','EMP_DETAILS_VIEW');--view

EXEC ddl_get_pkg.seq_proc('HR','DEPARTMENTS_SEQ');--seq

EXEC ddl_get_pkg.source_proc('HR','INDEX_COLUMN_FUNCTION');--function

EXEC ddl_get_pkg.source_proc('HR','INDEX_COLUMN_FUNCTION');--function

EXEC ddl_get_pkg.source_proc('HR','DML_LOGS');--tri

EXEC ddl_get_pkg.source_proc('HR','RESTORE_SQL_PROCEDURE');--proc

EXEC ddl_get_pkg.source_proc('SYS','DDL_GET_PKG');--package

select * from ddl_scripts
order by object_type,OBJECT_NAME,LINE ;

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