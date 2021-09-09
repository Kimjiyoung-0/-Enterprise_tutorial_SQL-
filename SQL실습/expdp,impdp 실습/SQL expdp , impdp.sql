SELECT * FROM dba_directories; 
-- expdp 명령어를 실습할 scott유저 생성
CREATE USER SCOTT
IDENTIFIED BY tiger
DEFAULT TABLESPACE users;
select * from dba_tablespaces ;

-- 로그인, 리소스 권한 부여
grant connect, resource to scott;

select * from user_tables;

-- 디폴트 테이블 스페이스 확인(디폴트 테이블 스페이스가 다르면 오류 발생)
select 
    username
    ,default_tablespace
    ,temporary_tablespace 
from dba_users 
where username = 'SCOTT' or username = 'HR';
-- 디폴트 설정
alter user HR default tablespace USERS;
-- 디렉토리를 만든다.
create directory pump_dir as '/app/oracle/19c/datapump';
-- 다시 실습할때를위한 삭제 명령
drop directory pump_dir;
-- 리눅스 커맨드라인에서 입력
-- 디렉토리에 hr.dmp이란 이름의 파일로 테이블 hr.emp,hr.dept 저장
expdp HR/HR dumpfile = hr.dmp directory = pump_dir tables=hr.emp,hr.dept;
-- 리눅스 커맨드라인에서 입력
-- 디렉토리에 test1.dmp이란 이름의 파일로 테이블 test1.DDL_SCRIPTS 저장
expdp test1/oracle dumpfile = test1.dmp directory = pump_dir tables=test1.DDL_SCRIPTS;

-- 테이블 스페이스 크기제한을 무한으로 늘린다.
alter user scott default tablespace USERS quota unlimited on users;
-- 디렉토리 읽는 권한을 준다.
grant read, write on directory pump_dir to scott;
--
-- EXP_FULL_DATABASE 데이터베이스 익스포트 권한
-- IMP_FULL_DATABASE 데이터베이스 임포트 권한
grant imp_full_database to scott;

-- 리눅스 커맨드라인에서 입력
-- import scott 계정에 hr.dmp 파일의 table hr.emp,hr.dept 정보 업로드 
impdp scott/tiger dumpfile = hr.dmp directory = pump_dir tables=hr.emp,hr.dept ;
-- content=data_only 오직 데이터만 업로드
impdp scott/tiger dumpfile = hr.dmp directory = pump_dir tables=hr.emp,hr.dept content=data_only;
-- remap_schema = hr:scott hr 스키마의 테이블을 scott 스키마로 임포트
impdp scott/tiger dumpfile = hr.dmp directory = pump_dir tables=hr.emp,hr.dept remap_schema = hr:scott;

drop user scott;
