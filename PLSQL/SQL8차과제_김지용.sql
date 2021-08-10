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

    select sys_context( 'userenv','session_user'),sys_context( 'userenv','host'),sys_context( 'userenv','module')
    into username_t,machine_t,module_t
    from dual;


    if updating then
        flag := 'u';
    elsif inserting then 
        flag := 'i';
    else
        flag := 'd';
    end if; 

    if inserting then   
        insert into emp_audit(username,action_time,action_flag,rid,machine,module ) 
        values(username_t,sysdate,flag,:new.rowid,machine_t,module_t);
    elsif updating or deleting then 
        insert into emp_audit(username,action_time,action_flag,rid,machine,module ) 
        values(username_t,sysdate,flag,:old.rowid,machine_t,module_t);
    end if;
    commit;
    exception
    when others then
        insert into emp_audit(username,action_time,action_flag,machine,module ) 
            values(username_t,sysdate,flag,machine_t,module_t);
    commit;
            
end;
