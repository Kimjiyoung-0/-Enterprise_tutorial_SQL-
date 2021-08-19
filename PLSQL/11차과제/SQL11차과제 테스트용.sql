EXEC restore_package.tab_procedure('HR','EMP');

EXEC restore_package.source_procedure('SYS','schedFileWatcherJava');

EXEC restore_package.ind_procedure('HR','EMP');



select * from ddl_scripts
order by object_type desc,OBJECT_NAME,LINE ;

delete  from ddl_scripts;

commit;


