select * from v$parameter;
select * from dba_tablespaces;
/*
data file
system 은 metadata를 보관한다.
sysaux systme의 역할 보조
temp 임시적인 작업(PGA에서 sort, join등의 작업을 할 공간이 부족하면 사용)
undo rollback명령어가 입력될시, undo에 담긴데이터를 이용해 rollback수행

*/
select * from dba_users;
select * from SYS.USER$;
select * from dba_segments
where segment_name like 'USER%';
/**/
select e.rowid from hr.EMPLOYEES e , hr.DEPARTMENTS d
where EMPLOYEE_ID = 100 ;
and e.DEPARTMENT_ID = d.DEPARTMENT_ID;
select * from v$log;
select * from sys.col$;
select * from DBA_TAB_COLUMNS;
select * from dba_rollback_segs;
select * from v$SQL;
select * from v$SQL_PLAN;
select * from v$bh;

select * from v$controlfile_record_section
/* 컨트롤파일관한정보를 보는 SQL문*/






