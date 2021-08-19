EXEC ddl_get_pkg.tab_proc('HR','EMP');

EXEC ddl_get_pkg.source_proc('SYS','schedFileWatcherJava');

EXEC ddl_get_pkg.ind_proc('HR','EMP');

EXEC ddl_get_pkg.view_proc('HR','EMP_DETAILS_VIEW');



select * from ddl_scripts
order by object_type desc,OBJECT_NAME,LINE ;

delete  from ddl_scripts;

commit;

--완료 목록
--table 
--index 
--PACKAGE BODY 
--TYPE BODY 
--TRIGGER
--PACKAGE 
--PROCEDURE 
--LIBRARY 
--FUNCTION 
--TYPE 
--JAVA SOURCE
--view 

--해야되는것들
--SEQ
--