select * from v$parameter;
select * from dba_tablespaces;
/*
data file
system �� metadata�� �����Ѵ�.
sysaux systme�� ���� ����
temp �ӽ����� �۾�(PGA���� sort, join���� �۾��� �ҋ� ������ �����ϸ� ���)
undo rollback��ɾ �Էµɽ�, undo�� ��䵥���͸� �̿��� rollback����

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
/* ��Ʈ�����ϰ��������� ���� SQL��*/






