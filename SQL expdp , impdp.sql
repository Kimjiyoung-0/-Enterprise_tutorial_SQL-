SELECT * FROM dba_directories; 
-- expdp ��ɾ �ǽ��� scott���� ����
CREATE USER SCOTT
IDENTIFIED BY tiger
DEFAULT TABLESPACE users;
select * from dba_tablespaces ;

-- �α���, ���ҽ� ���� �ο�
grant connect, resource to scott;

select * from user_tables;

-- ����Ʈ ���̺� �����̽� Ȯ��(����Ʈ ���̺� �����̽��� �ٸ��� ���� �߻�)
select 
    username
    ,default_tablespace
    ,temporary_tablespace 
from dba_users 
where username = 'SCOTT' or username = 'HR';
-- ����Ʈ ����
alter user HR default tablespace USERS;
-- ���丮�� �����.
create directory pump_dir as '/app/oracle/19c/datapump';
-- �ٽ� �ǽ��Ҷ������� ���� ���
drop directory pump_dir;
-- ������ Ŀ�ǵ���ο��� �Է�
-- ���丮�� hr.dmp�̶� �̸��� ���Ϸ� ���̺� hr.emp,hr.dept ����
expdp HR/HR dumpfile = hr.dmp directory = pump_dir tables=hr.emp,hr.dept;
-- ������ Ŀ�ǵ���ο��� �Է�
-- ���丮�� test1.dmp�̶� �̸��� ���Ϸ� ���̺� test1.DDL_SCRIPTS ����
expdp test1/oracle dumpfile = test1.dmp directory = pump_dir tables=test1.DDL_SCRIPTS;

-- ���̺� �����̽� ũ�������� �������� �ø���.
alter user scott default tablespace USERS quota unlimited on users;
-- ���丮 �д� ������ �ش�.
grant read, write on directory pump_dir to scott;
--
-- EXP_FULL_DATABASE �����ͺ��̽� �ͽ���Ʈ ����
-- IMP_FULL_DATABASE �����ͺ��̽� ����Ʈ ����
grant imp_full_database to scott;

-- ������ Ŀ�ǵ���ο��� �Է�
-- import scott ������ hr.dmp ������ table hr.emp,hr.dept ���� ���ε� 
impdp scott/tiger dumpfile = hr.dmp directory = pump_dir tables=hr.emp,hr.dept ;
-- content=data_only ���� �����͸� ���ε�
impdp scott/tiger dumpfile = hr.dmp directory = pump_dir tables=hr.emp,hr.dept content=data_only;
-- remap_schema = hr:scott hr ��Ű���� ���̺��� scott ��Ű���� ����Ʈ
impdp scott/tiger dumpfile = hr.dmp directory = pump_dir tables=hr.emp,hr.dept remap_schema = hr:scott;

drop user scott;