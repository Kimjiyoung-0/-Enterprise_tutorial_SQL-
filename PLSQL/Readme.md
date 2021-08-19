# PL/SQL실습 내용
## 자율 트랜잭션 
아래 Table에 EMP Table에 DML 작업을 수행한 정보를 입력하는 Trigger를 작성하시요.<br>
 단 실패하거나 Rollback한 경우에도 입력되도록 하시요.<br>
```SQL
create table emp_audit
 (username   varchar2(30),   
  action_time date,
  action_flag char(1),
  rid         rowid,
  machine     varchar2(64), -- session 정보에서 보이는 machine name
  module      varchar2(64)); -- session 정보에서 보이는 module name
 ```
==> action_flag  column에는 Update는 'U',Insert는 'I',Delete는 'D'<br>
     rid column에는 Update는 old.rowid,Insert는 new.rowid,Delete는 old.rowid 값을 넣을 것<br>
이라는 과제가 있을때 <br>
트리거로 insert, delete, update 이벤트를 감지하고, <br>
username과 machine name, module name은 sys_context()함수를 사용하여 해결하면된다. <br>
허나, 사용자가 롤백을 하고나서도 이 기록을 유지해야한다면 어떻게 할것인가<br>

바로 자율 트랜잭션을 사용한다.<br>

트리거 선언부에 변수와 같이<br>
 pragma autonomous_transaction;<br>
 를 선언하면 트리거내부에 commit을 사용할 수 있다.<br>

```SQL
create or replace trigger dml_logs 

    before insert or update or delete 
    on emp
    for each row
declare
    flag    char(1);
    username_t varchar2(30);
    machine_t varchar2(64);
    module_t varchar2(64);
    rowid_t rowid;
    pragma autonomous_transaction;

begin

    select 
        sys_context( 'userenv','session_user'),
        sys_context( 'userenv','host'),
        sys_context( 'userenv','module')
    into 
        username_t,
        machine_t,
        module_t
    from dual;


    if updating 
    then
        flag := 'u';
    elsif inserting 
    then 
        flag := 'i';
    else
        flag := 'd';
    end if; 

    if inserting then   
        insert into emp_audit
            (
                username,
                action_time,
                action_flag,
                rid,
                machine,
                module 
            ) 
        values
            (
                username_t,
                sysdate,
                flag,
                :new.rowid,
                machine_t,
                module_t
            );
            
    elsif updating or deleting then 
        insert into emp_audit
        (
            username,
            action_time,
            action_flag,
            rid,
            machine,
            module 
        ) 
        values
        (
            username_t,
            sysdate,
            flag,
            :old.rowid,
            machine_t,
            module_t
        );
        
    end if;
    commit;
    
    exception
    when others then
        insert into emp_audit
        (
            username,
            action_time,
            action_flag,
            machine,
            module 
        ) 
        values
       
        (
            username_t,
            sysdate,
            flag,
            machine_t,
            module_t
        );
    commit;   
end;
```
##  Data Dictionary
- 데이터 사전(Data Dictionary)이란 대부분 읽기전용으로 제공되는 <br>
- 테이블 및 뷰들의 집합으로 데이터베이스 전반에 대한 정보를 제공 한다.<br>
- 오라클 데이터베이스는 명령이 실행 될 때 마다 데이터 사전을 Access 한다.<br>

### 데이터 사전에 저장되는 내용은 아래와 같다.

 

- 오라클의 사용자 정보<br>

- 오라클 권한과 롤 정보<br>

- 데이터베이스 스키마 객체(TABLE, VIEW, INDEX, CLUSTER, SYNONYM, SEQUENCE..) 정보<br>

- 무결성 제약조건에 관한 정보<br>

- 데이터베이스의 구조 정보<br>

- 오라클 데이터베이스의 함수 와 프로지저 및 트리거에 대한 정보<br>

- 기타 일반적인 DATABASE 정보<br>

SELECT * FROM DICTIONARY;<br>
### Data Dictionary의 명명규칙<br>
오라클에서는 Dictionary의 이름을 붙이는데는 나름대로의 규칙이 있다. <br>
대체로 이름만 봐도 '이런 정보를 담고 있구나!'고 유추해볼 수 있다. 다음은 대표적인 Dictionary의 명명 규칙들이다.<br>

#### USER_XXX<br>
- 사용자가 사용하고 있는 Object와 관련된 정보.<br>
ex)USER_ADDM_FDG_BREAKDOWN, USER_ADDM_FINDINGS, USER_ADDM_INSTANCES, ...<br>

#### ALL_XXX<br>
- 현재 사용자가 접근이 가능한 Object에 관련된 정보.<br>
ex)ALL_ALL_TABLES, ALL_APPLY, ALL_APPLY_CHANGE_HANDLERS, ...<br>

#### DBA_XXX<br>
- DBA 권한을 가지고 있는 사용자만이 접근할 수 있는 정보.<br>
ex) DBA_OBJECTS, DBA_INDEXES, DBA_TABLES, ...<br>

#### V$_XXX<br>
- 서버의 성능이나 시스템관련 정보, 메모리, Lock 등에 관한 정보.<br>
ex )V$ACTIVE_INSTANCES, V$ACTIVE_SESS_POOL_MTH, V$ADVISOR_CURRENT_SQLPLAN, ...<br>
