
select * from user_tables;
/*
SQL 키워드에 *을 포함하여 테이블의 열 데이터 모두를
디스플레이 할 수 있음
select키워드 이후에 모든열을 나열하여 테이블의
모든 열을 디스플레이 할 수 있음
*/

select * from emp;
select deptno, loc from dept;
/*
열 이름을 콤마로 구분하여 
명시함으로써 테이블의 특정 열을
디스플레이 할 수 있음
*/

select ename, sal, sal+300
from emp;
/*
위의 예는 직원의 급여를 300달러 
증가시키기 위해 덧셈연산자를 사용하고
결과에 SAL+300 열을 디스플레이
열 sal+300은 dept 테이블의 새로운 열이 아님
*/
select ename as name, sal salary
from emp;
select ename "Name", sal*12 "Annual Salary"
From emp;
/*
AS 키워드는 열별칭 이름 앞에 사용
질의의 결과는 열 헤딩을 대문자로 나타냄
*/

select ename || job as "Employees"
from emp;
/*
연결연산자(||)를 사용하여 문자 표현식을 생성하기 위해 다른열,
산술 표현식 또는 상수 값에 열을 연결 할 수 있음
연산자 양쪽에 있는 열은 단일결과 열을 만들기 위해 조합됨
*/
select ename ||' '||' is a '||' '||job as "Employee Datails"
from emp;
/*
리터럴은 열 이름이나 열 별칭이 아닌, 
select 목록에 포함되어 있는 문자, 표현식 또는 숫자임
리턴되는 각각의 행에 대하여 출력됨
리터럴 스트링은 질의 결과에 포함될 수 있으며 
SELECT 목록에서 열과 같이 취급됨
날짜와 문자 리터럴은 단일 인용부호('')내에 있어야 함
*/
select distinct deptno
from emp;
/*
질의의 디폴트 디스플레이는 중복되는 행을 포함하는 모든행
SELECT 절에서 DISTINCT 키워드를 사용하여 중복되는 행을 제거
DISTINCT 키워드 뒤에 여러 개의 열을 명시할 수 있음
DISTINCT 키워드는 선택된 모든 열에 영향을 미치고, 결과는
모든 열의 distinct한 조합을 나타냄
*/
describe dept;
/*
*/

select ename, job, deptno
from emp
where job='CLERK';
/*
위에서 select문장은 업무가 cleck인 모든
종업원의 이름 업무 그리고 부서 번호를 검색
업무 clerk은 emp테이블의 job열과
일치되도록 하기 위해 대문자로 명시
되어야한다.
*/

select ename, job, deptno
from emp
where ename = 'JAMES';
/*
문자 스트링과 날짜 값은 단일 인용부호('')로 둘러싸여 있다.
문자 값은 대소문자를 구분하고 날짜 값은 날짜 형식을 구분한다.
디폴트 날짜 형식은 'DD-MON-YY'이다.
*/

select ename, sal
from emp
where sal between 1000 and 1500;
/* 값의 범위에 해당하는 행을 디스플레이
할 수 있다. 명시한 범위는 하한 값과
상한 값을 포함한다. 아래의 
select문장은 급여가 $1000 에서
$1500사이에 있는 종업원에 대해서 
EMP테이블로부터 행을 리턴
*/

select empno, ename, sal, mgr
from emp
where mgr in(7902,7566,7788);
/* 명시된 목록에 있는 값에 대해서 테스트하기 위해, 
아래의 예는 관리자의 종업원 번호가 7902, 7566, 7788인 
모든 종업원의 종업원 번호, 이름, 급여 그리고 관리자의 종업원 번호를
디스플레이 한다.
*/

select ename
from emp
where ename like 'S%';
/* like 연산자 사용 
검색 스트링 값에 대한 와일드 카드 검색을 
위해서 like 연산자를 사용한다.
검색조건은 리터럴 문자나 숫자를 포함 할 수 있다.
%는 문자가 없거나 또는 하나 이상을 나타낸다.
_는 하나의 문자를 나타낸다.
*/
select ename, mgr
from emp
where mgr is null;
/*
null값은 값이 없거나 알 수 없거나 
또는 적용할 수 없음을 의미한다.
그러므로 null값은 어떤 값과 같거나 
또는 다를 수 없으므로 = 로는 테스트 할 수 없다.
*/
select empno, ename, job, sal
from emp
where sal>=1100
and job='CLERK';
/*
양쪽의 조건이 참이어야 한다. 업무가 CLERK이고 
급여가 $1100이상인 종업원이 선택됨
*/

select empno, ename, job, sal
from emp
where sal>=1100
or job='CLERK';
/*
한쪽의 조건만 참이면 된다.
업무가 CLERK이거나 급여가 $1100이상인
종업원이 선택됨
*/

select ename, job
from emp
where job not in('CLERK','MANAGER','ANALYST');
/*
업무가 CLERK, MANAGER 또는 ANALYST가 아닌
모든 종업원의 이름과 업무를 
디스플레이 한다.
*/


select ename, job, sal
from emp
where job='salesman'
or job='president'
and sal>1500;
/*
업무가 PRESIDENT이고 $1500이상을 벌거나 또는
업무가 SALESMAN인 행을 검색한다.
*/

select ename, job, sal
from emp
where (job='salesman'
or job='president')
and sal>1500;
/*우선 순위를 강제로 바꾸기 위해서
괄호를 사용한다.
업무가 PRESIDENT 이거나 SALESMAN 이고 
$1500 이상을 버는 행을 검색한다.
*/

SELECT ename, job, deptno, hiredate
FROM emp
ORDER BY hiredate;
/*
ASC: 오름차순 , 디폴트 설정
DESC: 내림차순
*/

select  ename, job, deptno, hiredate
from emp
order by hiredate DESC;

select empno, ename, sal*12 annsal
from emp
order by annsal;
/*
order by 절에서 열 별칭을 사용할 수 있다.
위는 연봉으로 데이터를 정렬
*/

select ename, deptno, sal
from emp
order by deptno, sal desc;
/*
하나 이상의 열로 질의 결과를 정렬할 수 있다.
주어진 테이블에 있는 열의 개수 까지만 가능함.
ORDER BY절에서 열을 명시하고 열 이름뒤에
DESC를 명시한다. SELECT 절에 포함되지 
않는 열로 정렬할 수 도있다.
*/
select ename,(SYSDATE-hiredate)/7 weeks
from emp
where deptno =10;
/*
month_between('01-sep-95','11-jan-94')= 19.6774149,
add_months('11-jan-94',6) = 11-JUL-94,
next_day('01-sep-95','friday') = '08-sep-95',
last_day('01-sep-95') = '30-sep-95',
round('25-jul-95','month') = 01-AUG-95
round('25-jul-95','year') = 01-jan-96
trunc('25-jul-95','month')=01-jul-95
trunc('25-jul-95','year')=04-jan-95
*/
/*
NVL 함수
Null 값을 실제 값으로 변환
사용될 수 있는 데이터형은 날짜, 문자, 숫자.
데이터형은 일치해야 함.
NVL(comm, 0)
NVL(hiredate,'01-JAN-97')
NVL(job,'No Job Yet')
*/
select job, sal, Decode(job, 'ANALYST', sal * 1.1,
                        'CLERK', sal * 1.15,
                        'MANAGER', sal * 1.20,
                        sal) Revised Salary from EMP;
                        
select avg(salary), min(salary), max(salary), sum(salary)
from employees
where job_id like '%REP%';

select
min(hire_date),max(hire_date)
,min(last_name), max(last_name)
from EMPLOYEES;

select
min(hire_date),max(hire_date),
min(last_name),max(last_name)
from employees;
/*
문자열 날짜열 min-max사용
*/
select
count(*),
count(distinct department_id),
count(department_id),
count(all DEPARTMENT_id)
from EMPLOYEES
where department_id = 50;
/*
count 사용
*/
select
count(commission_pct),
count(department_id)
from EMPLOYEES
where DEPARTMENT_id = 80;
/*
null 여부
*/
select
distinct
count(distinct department_id)
from EMPLOYEES;

select avg(commission_pct), avg(nvl(commission_pct, 0))
from EMPLOYEES;

select DEPARTMENT_id, avg(salary)
from EMPLOYEES
group by department_id;

select
avg(salary)
from EMPLOYEES
group by department_id;

select
DEPARTMENT_id, job_id, sum(salary), avg(salary),
min(salary), max(salary)
from EMPLOYEES
group by DEPARTMENT_id, job_id;

select
DEPARTMENT_id
,count(last_name)
from EMPLOYEES;
/*에러 */

select
DEPARTMENT_id
,count(last_name)
from EMPLOYEES
where avg(salary) > 8000
group by DEPARTMENT_id;
/*where절 에러난*/

select
department_id
,count(last_name)
from EMPLOYEES
group by DEPARTMENT_id
having avg(salary) > 8000;

select 
DEPARTMENT_id, max(salary)
from EMPLOYEES
group by DEPARTMENT_id
having max(salary) > 10000;

select job_id, sum(salary)
from EMPLOYEES
where job_id not like '%REP%'
group by job_id
having sum(salary) > 1300
order by sum(salary);

select max(avg(salary))
from EMPLOYEES
group by DEPARTMENT_id;

select max(abc)
from (select avg(salary) abc
from EMPLOYEES
group by DEPARTMENT_id)b;

select last_name, DEPARTMENT_name
from EMPLOYEES cross join DEPARTMENTS;
/*CROSS 조인은 두 테이블의 곱집합을 생성합니다.*/
/*이는 두 테이블 간의 Cartesian 곱과 같습니다.*/

/*
NATURAL 조인
*NATURAL 조인은 두 테이블에서 같은 이름을 가진
모든 칼럽에 기반합니다.
*두 테이블의 대응되는 모든 컬럼에 대해
같은 값을 가지는 행들을 선택합니다.
*만일 같은 이름을 가지는 컬럼들이 서로
다른 데이터 형을 가질때에는 오류가 반환됩니다.
*만일 SELECT * 문법을 사용한다면, 공통 컬럼들은 
결과집합에서 단 한번만 나타납니다.
*테이블 이름이나 가명 등의 수식자들은 NATURAL
조인에 사용된 컬럽들을 수식할 수 없습니다.
*/

select DEPARTMENT_id, location_id
from locations natural join DEPARTMENTS;
/*
using 절을 이용한 조인
만일 여러 개의 컬럼이 이름은 같지만 데이터 형이 모두
일치되지는 않을 때에는, NATURAL JOIN은 USING절을 
이용하여 동등 조인에 사용될 컬럼들을 명시하도록 수정
될 수 있습니다.
*USING 절에서 참조되는 컬럼들은 SQL 문 
어디에서도 수식자(테이블 이름이나 가명)에
의해 수식될 수 없습니다.
NATURAL 과 USING의 두 키워드는 상호 배타적으로
사용됩니다.
*/
select e.EMPLOYEE_id, e.last_name, d.LOCATION_id
from EMPLOYEES e join DEPARTMENTS d
using (DEPARTMENT_id);

/*
on 절을 사용하는 조인
Natural 조인의 조인 조건은 기본적으로 같은 이름을 가진 모든
컬럼들에 대한 동등 조건입니다.

임의의 조인 조건을 지정하거나, 또는 조인할 컬럼을 명시하기
위해서 on절이 사용됩니다.

on절은 조인 조건과 다른 조건들을 분리합니다.
on절은 코드를 보다 이해하기 쉽게 합니다.
*/
select e.employee_id, e.last_name, e.department_id, d.department_id,
d.location_id
from EMPLOYEES e join DEPARTMENTS d
on(e.department_id = d.department_id);
/*
복잡한 조인
On절을 사용합으로써 다음과 같은것들을 이용한 복잡한 
조인을 만들 수 있습니다.

조인 조건과 on절
on절을 사용함으로써 다른조건과 조인 조건을 분리시킬수 있습니다.
그렇게 하면 코드가 보다 이해하기 쉬워집니다.
on절은 서브쿼리나 논리 연산자 등을 포함한 임의의 조건을
지정할 수 있습니다.
*/
select e.manager_id, e.last_name ,
d.department_id, d.location_id
from EMPLOYEES e join DEPARTMENTS d
on((e.department_id = d.DEPARTMENT_id)
    and
    e.manager_id =102
);

select DEPARTMENT_name, city
from locations l join DEPARTMENTS d
on((l.location_id = d.LOCATION_id)
    and not exists(
    select 1 from EMPLOYEES e
    where e.DEPARTMENT_id = d.DEPARTMENT_id
    )
);

select EMPLOYEE_id, city, DEPARTMENT_name
from LOCATIONS l
join DEPARTMENTS d
on (l.LOCATION_id = d.LOCATION_id)
join EMPLOYEES e
on (d.DEPARTMENT_id = e.department_id);

/*
INNER 대 OUTER 조인
SQL : 두테이블을 조인하여 오로지
대응되는 행들만을 반환하는 것을
INNER 조인이라 합니다.

INNER 조인의 결과 함께 왼쪽(오른쪽) 테이블의 대응되지
않는 행들도 반환하는 것을 LEFT (RIGHT) OUTER 조인이라고 합니다.

INEER 조인의 결과와 함께 LEFT 및 RIGHT OUTER
조인의 결과까지 모두 반환하는 것을 FULL OUTER 조인
이라 합니다.
*/

select e.last_name, d.DEPARTMENT_name
from EMPLOYEES e left outer join DEPARTMENTS d
on(e.DEPARTMENT_id = d.DEPARTMENT_id);

select e.last_name, d.DEPARTMENT_name
from EMPLOYEES e right outer join DEPARTMENTS d
on(e.DEPARTMENT_id = d.DEPARTMENT_id);

select e.last_name, d.DEPARTMENT_name
from EMPLOYEES e full outer join DEPARTMENTS d
on(e.DEPARTMENT_id = d.DEPARTMENT_id);

/*
하나 이상의 테이블로부터 데이터를 질의하기 위해서 JOIN을 사용함.
테이블의 행은 관련되는 열의 공통 값(Primary Key 와 Foreign Key)열에 따라서
다른 하나의 테이블의 행과 Join할 수 있음.

WHERE 절에 조인 조건(Join Condition)을 작성함.
하나 이상의 테이블에 똑같은 열 이름이 있을때,
열 이름앞에 테이블 이름을 붙임.
*/

select emp.empno, emp.ename, emp.deptno, dept.deptno, dept.loc
from emp join dept
on emp.deptno = dept.deptno;

select e.empno, e.ename, e.deptno, d.deptno, d.loc
from emp e join dept d
on e.deptno = d.deptno;

select e.ename, e.sal, s.grade
from emp e join SALGRADE s
on e.sal between s.losal and s.hisal;

select e.ename, d.deptno, d.dname
from emp e right outer join dept d
on e.deptno = d.deptno order by e.deptno;

select worker.ename || 'works for' || manager.ename
from emp worker join emp manager
on worker.mgr = manager.empno;
/*
서브쿼리가 해결 할 수 있는 문제의 유형을 기술
서브쿼리를 정의
서브쿼리의 유형을 나열
단일 행 서브쿼리와 다중 행 서브쿼리를 작성
*/

select ename
from emp
where sal> (select sal from emp where empno=7566);

/*
서브쿼리 사용지침
*서브쿼리는 괄호로 둘러싸여야 함
*서브쿼리는 비교 연산자의 오른쪽에 위치 하여야함
*서브쿼리에 ORDER BY절을 포함하지 말 것
*select 문장에는 오직 하나의 order by 절이 올 수 
있으며 문장의 끝에 위치하여야 함
*단일 행 서브쿼리에는 단일 행 연산자를 사용
*다중 행 서브쿼리에는 다중 행 연산자를 사용
*/
select ename,job
from EMP
where job= (select job from emp where empno=7369)
and sal > (select sal from emp where empno=7876);

select ename, job, SAL
from EMP
where sal = (select min(sal) from emp);

select deptno, MIN(sal)
from EMP
group by deptno
having min(sal) >(select min(sal) from emp where deptno =20);
/*
다중 행 서브쿼리
in 목록의 어떤 구성원과 같다
any 값을 서브쿼리에 의해 리턴된 각각의 값과 비교한다
all 값을 서브쿼리에 의해 리턴되는 모든 값과 비교한다
*/

select empno, ename, job
from EMP
where sal<ANY(select sal from emp where job='CLERK')
AND job<>'CLERK';

select empno, ename, job
from EMP
where sal> all(select avg(sal) from emp group by deptno);

/*
서브쿼리는 다른 SQL 문장의 절에 내장된
SELECT문으로 미지정된 값을 근거로 할 때 
유용함
*데이터의 한 행을 =,<>,>,>=,<,<=같은 단일 행 연산자를
포함하는 메인 문장으로 전달할 수 있음
*데이터의 다중 행을 IN 과 같은 다중 행
연산자를 포함하는 메인문자으로 전달할 수 있음
*서브쿼리는 오라클 서버에 의해서 먼저 처리된 다음에 
Where 또는 Having절이 그 결과를 사용
*그룹함수를 포함할 수 있음
*/
