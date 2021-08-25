create user test1 identified by oracle;

grant connect, resource to test1;

alter user test1 default tablespace users quota unlimited on users;

-- system계정으로 먼저 synonym을 만든다.
--
CREATE OR REPLACE PUBLIC SYNONYM syn_tab_columns FOR dba_tab_columns; -- 테이블 조회를 위한 시노님
CREATE OR REPLACE PUBLIC SYNONYM syn_source      FOR dba_source; -- 펑션, 프로시저, 패키지 조회를 위한 시노님
CREATE OR REPLACE PUBLIC SYNONYM syn_ind_columns FOR dba_ind_columns ; -- 인덱스 조회를 위한 시노님
CREATE OR REPLACE PUBLIC SYNONYM syn_views       FOR dba_views; -- 뷰 조회를 위한 시노님
CREATE OR REPLACE PUBLIC SYNONYM syn_sequences   FOR dba_sequences; -- 시퀸스 조회를 위한 시노님
CREATE OR REPLACE PUBLIC SYNONYM syn_synonyms    FOR dba_synonyms; --시노님 조회를 위한 시노님

-- 그다음 select권한을 부여해서 다른계정이 select할 수 있도록 조치한다.
--이때 select권한을 테이블 , 시노님 두번을 줘야한다.

--시노님 select 권한 부여 
GRANT SELECT ON syn_tab_columns TO  test1;
GRANT SELECT ON syn_source      TO  test1;
GRANT SELECT ON syn_ind_columns TO  test1;
GRANT SELECT ON syn_views       TO  test1;
GRANT SELECT ON syn_sequences   TO  test1;
GRANT SELECT ON syn_synonyms    TO  test1;
--테이블 select 권한 부여 
GRANT SELECT ON dba_tab_columns TO  test1;
GRANT SELECT ON dba_source      TO  test1;
GRANT SELECT ON dba_ind_columns TO  test1;
GRANT SELECT ON dba_views       TO  test1;
GRANT SELECT ON dba_sequences   TO  test1;
GRANT SELECT ON dba_synonyms    TO  test1;

--이 다음은 패키지를 선언한다.
--
--패키지 프로시저 실행 부분

EXEC ddl_get_pkg.tab_proc   ('HR','EMP');--table

EXEC ddl_get_pkg.ind_proc   ('HR','EMP');--index

EXEC ddl_get_pkg.view_proc  ('HR','EMP_DETAILS_VIEW');--view

EXEC ddl_get_pkg.seq_proc   ('HR','DEPARTMENTS_SEQ');--seq

EXEC ddl_get_pkg.source_proc('HR','INDEX_COLUMN_FUNCTION');--function

EXEC ddl_get_pkg.source_proc('HR','DML_LOGS');--tri

EXEC ddl_get_pkg.source_proc('HR','RESTORE_SQL_PROCEDURE');--proc

EXEC ddl_get_pkg.source_proc('SYS','DDL_GET_PKG');--package

EXEC ddl_get_pkg.syn_proc   ('SYS','SYN_SYNONYMS');--synonym

--결과물 조회
select * from ddl_scripts
order by object_type,OBJECT_NAME,LINE ;
--지우기 
delete  from ddl_scripts;
commit;


--완료 목록
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