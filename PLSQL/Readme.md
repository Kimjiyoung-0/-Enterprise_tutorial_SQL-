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
