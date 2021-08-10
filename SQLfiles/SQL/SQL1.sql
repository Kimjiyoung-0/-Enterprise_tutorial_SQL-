describe EMPLOYEES;
select EMPLOYEe_id , job_id
from EMPLOYEES
union
select EMPLOYEE_id, job_id
from job_history;

select EMPLOYEE_id, job_id
from EMPLOYEES
union all
select EMPLOYEE_id, job_id
from JOB_HISTORY;

select EMPLOYEE_id, job_id
from EMPLOYEES
INTERSECT
select EMPLOYEE_id, job_id
from JOB_HISTORY;

select EMPLOYEE_id, job_id
from JOB_HISTORY
minus
select EMPLOYEE_id, job_id
from EMPLOYEES;

 
 commit;
 
 select DEPARTMENT_id,count(*) 
 from EMPLOYEES
 where salary >= 10000
 group by DEPARTMENT_id;
  
 
 select EMPLOYEE_id, last_name, salary, commission_pct
 from EMPLOYEES;
 
 update nine
 set id = '1' 
 where id = 'first';
 
 
 create table ten(
    id char(5),
    name char(15) not null,
    dept char(15),
    primary key(id)
 
 )
 
