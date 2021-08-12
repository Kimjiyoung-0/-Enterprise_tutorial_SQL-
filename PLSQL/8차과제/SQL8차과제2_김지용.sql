create or replace trigger dml_logs 
    before insert or update or delete 
    on emp
    for each row
declare
    flag    char(1);
    username_t varchar2(30) :=sys_context( 'userenv','session_user');
    machine_t varchar2(64) :=sys_context( 'userenv','host');
    module_t varchar2(64) :=sys_context( 'userenv','module');
    rowid_t rowid;
    pragma autonomous_transaction;

begin
    if updating then
        flag := 'u';
        rowid_t := :old.rowid;
    elsif inserting then 
        flag := 'i';
        rowid_t := :new.rowid;
    else
        flag := 'd';
        rowid_t := :old.rowid;
    end if; 
   
    insert into emp_audit(username,action_time,action_flag,rid,machine,module ) 
    values(username_t,sysdate,flag,rowid_t,machine_t,module_t);
    commit;

        
    
end;
