/*
UNION 집합 연산자
첫번째 Query와 두번째 QUERY의 중복된 정보는 한번 만 보여줌
(열의 개수와 타입이 동일해야 함)
select * from jisa union select * from bonsa;
*/
/*
UNION ALL 연산자
첫번째 Query와 두번째 Query에 있는 노듬 데이터를 보여줌
SELECT * FROM jisa UNION ALL select * FROM bonsa;
*/
/*
MINUS 연산자
두번째 Query에는 없고 첫번째 Query에 만 있는 데이터를 보여줌
select * from jisa MINUS select * from bonsa;
*/
/*
INTERSECT 연산자
두번째 Query와 첫번째 Query에서 중복된 데이터를 보여줌
SELECT *FROM jisa INTERSECT SELECT * FROM bonsa;
*/
/*
집합 쿼리(UNION, INTERSECT, MINUS)
집합 연사자를 사용시 집합을 구성할 컬러의 데이터 
타입이 동일해야 합니다.
UNION : 합집합
UNION ALL : 공통원소 두번씩 다 포함한 합집합
INTERSECT : 교집합
MINUS : 차집합
*/

/*
2) 데이터 조작어
DML 문장을 실행하는 경우
테이블에 새로운 행을 추가
테이블에 있는 기존의 행변경
테이블로부터 기존의 행제거

트랜잭션은 작업의 논리적인 단위 형태인
DML의 모음으로 구성됨
*/
/*
insert 문장 
insert 문장을 사용하여 테이블에 새로운 행을 추가함
이구문 형식은 한번에 오직 하나의 행만이 삽입됨.
*/
insert into dept(deptno, dname, loc)
values(50,'DEVELOPMENT','DETroit');
/*
새로운 행 삽입
*각각의 열에 대한 값을 포함하는 새로운 행을 삽입함.
*테이블에 있는 열의 디폴트 순서로 값을 나열함.
*INSERT 절에서 열을 선택적으로 나열함.
*문자와 날짜 값은 단일 따옴표('')내에 둠.
*/
INSERT INTO dept(deptno, dname, loc)
values (50, 'DEVELOPMENT', 'DETROIT');
/*
Null 값을 가진 새로운 행 추가

1) 암시적 방법
-열 목록으로부터 열을 생략함
*/
INSERT INTO dept(deptno, dname)
values (60, 'MIS');
/*
2) 명시적 방법
NULL 키워드를 명시함.
*/
insert into dept
values (70, 'FINANCE',NULL);
/*
SYSDATE 함수 
현재 날짜와 시간을 기록함
*/
INSERT INTO emp(empno, ename, job, mgr, hiredate, sal, comm, deptno)
values(7196, 'GREEN','SALESMAN',7782,SYSDATE,2000,NULL,10);

INSERT INTO EMP
VALUES(2296, 'AROMANO','SALESMAN',7782,TODATE('FEB,3,97','MON,DD,YY'), 1300, NULL, 10);

INSERT INTO dept(deptno, dname, loc)
VALUES (&department_id, &department_name,&location);

insert into managers(id, name, salary, hiredate)
        select empno, ename, sal, hiredate
        from EMP
        where job = 'MANAGER';
 
 
 update EMP
 set deptno=20
 where empno = 7782;
 
 update employe
 set deptno = 20;
 
 update EMP
 set (job, deptno)=(select job, deptno
                    from EMP
                    where empno=7499)
where empno=7698;

update EMP
set deptno = (select deptno
                from EMP
                where empno = 7788)
where job = (select job
            from EMP
            where empno = 7788);
 
 delete from department
 where dname='DEVELOPMENT';
 
 /*
 데이터베이스 트랜잭션
 트랜잭션은 다음 문장 중 하나로 구성됨
 *데이터를 일관되게 변경하는 하나 이상의 DML 문장
 *하나의 DDL 문장
 *하나의 DCL 문장
 *실행 가능한 첫 번째 SQL 문장이 실행될 때 시작함.
 *다음 이벤트 중 하나로 종료됨.
 *COMMINT 또는 ROLLBACK
 DDL 또는 DCL 문장 실행(자동 커밋)
 사용자 종료
 시스템 파손
 
 */
 
 /*
 COMMIT과 ROLLBACK의 장점
 *데이터 일관성을 제공함
 *데이터의 영구적으로 변경하기 전에
 데이터 변경을 미리 보도록 함.
 *관련된 작업을 논리적으로 그룹화 함.
 */
 
 /*
 암시적 트랜잭션 처리
 자동적인 COMMIT은 다음 환경 하에서 발생
 DDL 문장이 완료 시
 DCL 문장이 완료 시
 명시적인 COMMIT 또는 ROLLBACK 없이
 SQL*PLUS를 그냥 종료시킬 때
 */
 /*
 자동적인 ROLLBACK은 
 SQL*PLUS를 비정상적으로 종료 ORACLE_OCM
 시스템 실패 하에서 발생 함.
 */
 /*
 COMMIT 또는 ROLLBACK 이전의 데이터 상태
 *데이터의 이전 상태는 복구될 수 있음.
 *현재 사용자는 SELECT 문장을 사용하여 
 DML 작업의 결과를 검토할 수 있음.
 *다른 사용자들은 현재 사용자에 의한
 DML 문장의 결과를 볼 수 없음.
 *변경된 행들은 잠금 상태(Locked)임.
 다른 사용자들은 변경된 행들 내의 데이터를 변경할 수 없음.
 */
 /*
 COMMIT 이후의 데이터 상태
 *데이터베이스에 영구적으로 데이터를 변경함
 *데이터의 이전 상태는 완전히 상실됨.
 *모든 사용자가 결과를 볼 수 있음.
 *변경된 행들의 잠금 상태가 해제됨.
 => 잠금 상태가 해제된 행들은
 다른 사용자가 조작하기 위해 이용가능함
 *모든 savepoint가 제거됨.

 */
 /*
 ROLLBACK 이후의 데이터 상태
 *ROLLBACK 문장을 사용하여 모든 결정되지 않은 변경들을 버림
 데이터 변경이 취소됨.
 데이터는 이전 상태로 복구 됨.
 변경된 행들의 잠금 상태가 해제됨.
*/
/*
표시자(Marker)으로 변경을 롤백
SAVEPOIN 문장을 사용하여
현재 트랜잭션 내에 표시자(Marker)를 생성함
ROLLBACK TO SAVEPOINT 문장을 사용하여
표시자(marker)까지 롤백 함.
*/
 
 /*
 문장 레벨 롤백
 *실행동안에 단일 DML문장이 실패하면, 단지 그 문장만을 롤백 함.
 *오라클 서버는 암시적인 savepoint를 구현함.
 *모든 다른 변경들은 보유 됨.
 *사용자는 COMMIT 또는 ROLLBACK 문자을 실행하여
 명시적으로 트랜잭션을 종료함.
 */
 
 /*
 읽기 일관성
 *읽기 일관성은 항상 데이터의 검색이 일관되게 보증함.
 *어떤 사용자에 의해 행해진 변경은
 다른 사용자에 의해 행해진 변경과 충돌하지 않음
 *데이터를 똑같게 보증함.
 
 */
 
 /*
 잠금(Locking)
 동시 트랜잭션 사이의 상호 작용이 파괴를 막아 줌.
 사용자 액션을 요구하지 않음.
 자동적으로 가장 낮은 레벨이 제약 조건을 사용함.
 트랜잭션이 지속되도록 함.
 2가지의 기본적인 모드를 가짐.
 Exclusive(독점)
 Share(공유)
 */
 /*
 INSERT 테이블에 새로운 행을 추가 
 UPDATE 테이블에 있는 기존의 행을 수정
 DELETE 테이블로부터 기존의 행을 제거 
 COMMIT 모든 변경을 영구적으로 변경함.
 SAVEPOINT Savepoint marker 까지를 롤백
 ROLLBACK 모든 확정되지 않은 변경를 바꿈.
 */
 /*
 Table 행과 열로 구성된 기본적인 저장 매체의 단위
 View 하나 이상의 테이블로부터 데이터의 부분집합을
 논리적으로 표현
 Sequence 기본 키 값을 발생
 Index 어떤 질의의 성능을 향상
 Synonym 객체에 대체 이름을 부여
 */
 /*
 뷰(View)
 테이블 또는 다른 뷰를 기초로 하는 논리적 테이블
 뷰는 그 자체로서 소유하는 데이터는 없지만 창문처럼
 창문을 통해 어떤 데이터를 보거나 변경할 수 있다.
 물리적으로 존재하는 릴레이션은 아니며 질의와 
 같은 수식에 의해 정의된 것
 그러나 물리적으로 존재하는 일반 릴레이션과 유사하게 
 뷰에 대해 질의 할 수 있으며 어떤 경우에는 
 뷰 자체를 변경할 수 있다.
 */
 /*
 뷰의 사용 목적은?
 DB 선택적인 부분을 디스플레이 할 수 있기 때문에 데이터베이스에 
 대한 엑세스를 제한 할 수 있다.
 복잡한 질의로부터 결과를 검색하기 위한 단순한 질의를 만든다.
 사용자와 어플리케이션 프로그램에 대한 데이터 독립성을 제공한다.
 하나의 뷰는 여러 개의 테이블로부터 데이터를 검색하는데
 사용될 수 있다.
 */
create view empvu10
as select empno, ename, job
from EMP
where deptno=10;

describe empvu10;

create view salvu30
as select empno employee_number, ename NAME
            ,sal SALARY
FROM  EMP
where deptno=30;

select *
from salvu30;

create or replace view empvu10
    (employee_number, employee_name, job_title)
    as select empno, ename, job
    from EMP
    where deptno=10;
/*
단순 뷰에서 DML 연산을 수행할 수 있다.
뷰가 다음을 포함한다면 행을 제거할 수 없다.
-그룹 함수
-GROUP BY 절
-DISTINCT 키워드
* 뷰가 다음을 포함한다면 뷰에서 데이터를 수정할 수 없다.
-이전 슬라이드에서 언급된 임의의 조건
- 표현식으로 정의된 열
-ROWNUM 의사열
*다음을 표함 한다면 뷰에 데이터를 추가할 수 없다.
-뷰가 이전 슬라이드 또는 위에 언급된 임의의 조건을 포함할 때
-뷰에 의해 선택되지 않은 NOT NULL 열이 기본 테이블에 있을때
*/

/*
WITH CHECK OPTION절 사용
뷰에 대한 DML 연산이 뷰의 조건을 만졸할 때만 수행되도록한다.
*/
CREATE OR REPLACE VIEW empvu20
As select *
from EMP
where deptno=20
with check option constraint empvu20_ck;
/*
with check option절 사용
뷰를 통해 참조 무결성 체크를 수행하는 것이 가능하다.
또한 DB 레벨에서 제약조건을 적용할 수 있다.
뷰는 데이터 무결성을 보호하기 위해 사용될 수 있지만
사용은 매우 제한된다. 뷰를 통해 수행되는 INSERT와 
UPDATE는 WITH CHECK OPTION 절이 있으면 뷰를 가지고
검색할 수 없는 행 생성을 허용하지 않음을 명시한다.
*/

/*
DML 연산부정
뷰의 정의에 WITH READ ONLY 옵션을 추가하여 
DML 연산이 수행될 수 없게 한다.
*/
CREATE OR REPLACE VIEW empvu10
(employee_number, employee_name, job_title)
as select empno, ename, job
from EMP
where deptno =10
with read only;
/*
뷰의 임의의 행에서 DML을 수행하려고 하면 
오라클 서버 에러 ORA-01752가 발생한다.
*/

/*
뷰 제거
뷰는 데이터베이스에서 기본 테이블을 기반으로 하기 때문에
데이터 손실 없이 뷰를 삭제한다.
뷰를 제거하기 위해 DROP VIEW 문장을 사용한다.
이 문장은 데이터베이스에서 뷰 정의를 제거한다. 
뷰 삭제는 뷰가 만들어진 기본 테이블에는 영향을 미치지 않는다.
그 뷰에 기초하여 만들어진 뷰 또는 다른 어플리케이션은 무효화 된다.
생성자 또는 DROP ANY VIEW권한을 가진 사람만 뷰를 제거 할 수 있다.

*/
/*
뷰는 다른 테이블 또는 다른 뷰의 데이터에서 유래된다.
뷰는 다음의 장점을 제공한다.
-데이터베이스 액세스를 제한다.
-질의를 단순화한다.
-데이터 독립성을 제공한다.
-동일 데이터의 다중 뷰를 허용한다.
-근본적인 데이터를 제거하지 않고도 삭제될 수 있다.
*/
/*
시퀀스 
자동적으로 유일번호 생성
공유 가능한 객체
주로 기본키 값을 생성하기 위해 사용
메모리에 캐쉬되면 시퀀스값을 액세스 하는 효율향상
*/
Create Sequence dept_deptno
    INCREMENT BY 3
    START WITH 91 MAXVALUE 100
    NOCYCLE NOCACHE;

select sequence_name, min_value, max_value,
        increment_by, last_number
From user_sequences;

select * 
from user_sequences;
/*
Last_Number열은 다음 이용 가능한 시퀸스 번호를 표시
Nextval 과 Currval
Nextval은 다음 사용 가능한 시퀸스 값을 반환
Currval은 현재 시퀸스 값
*/
/*
시퀸스 사용-1
*서브쿼리의 일부가 아닌 Select 문장의 Select
리스트
*Insert 문장에서 서브쿼리 Select 리스트
*Insert 문장의 Values 절
*Update 문장의 Set절
*새로운 레코드 삽입시 Nextval을 사용하여 기본키 생성
*현재값을 확인 하기 위해서 더미 테이블을 이용 하여
Currval 값 확인
*/
Select user_sequences.currval from dual;
/*
시퀸스 사용-2
*메모리에서 시퀸스 값을 캐쉬하는 것은 이 값에
대해 더 빠른 낵세슬르 허용
*시퀸스 값에서 간격 발생 상황
-Rollback 발생
-System 실패
-여러 테이블에서 사용시
*USER_SEQUENCES 테이블을 질의하여
NOCACHE로 생성된 때에 한해서 다음 사용 가능한 
시퀸스 확인
*/
alter sequence dept_deptno
    INCREMENT BY 1
    Maxvalue 999999
    nocache
    nocycle;
/*
*증가값, 최대값, 최소값, 사이클 옵션 또는 캐쉬 옵션 변경
*시퀸스에 대한 ALTER 권한 소유시
*새로운 번호에서 시작하려면 다시 생성 해야함

시퀸스 제거
*DROP SEQUENCE 문장을 사용하여 데이터 사전에서 
시퀸스 제거
*한번 제거 되었다면 더 이상
참조될 수 없다.

인덱스란?
*스키마 객체
*포인터를 사용하여 행의 검색을 촉진하기 위해
오라클 서버가 사용
*빠르게 데이터를 찾기 위해 빠른 경로 액세스 방법을 
사용하여 디스크 I/O를 경감
* 인덱스하는 테이블에 대해 독립적
* 오라클 서버에 의해 자동적으로 사용되고 유지
*/
/*
인덱스 생성 방법
*자동
-테이블 정의시 PRIMARY KEY 또는 UNIQUE KEY 
제약조건을 정의 할 때 자동 생성
*수동
-행에 대한 액세스 시간을 향상 시키기 위해
열에서 유일하지 않은 인덱스를 생성할 수 있다.

*/
create index emp_ename_idx
on emp(ename);
/*
인덱스 생성 지침

인덱스 생성
* WHERE 절이나 조인 조건에 자주 사용하는 열
* 광범위한 값을 포함하는 열
* 많은 수의 널 값을 포함하는 열
* 대형 테이블이 대부분 질의어가 행의 2~4%보다 적게 읽어 들일 것으로 예상되는 
테이블
인덱스 생성 자제
*테이블이 작을경우
*질의 빈도가 낮은 열
*대부분 질의가 행의 2-4%이상 읽어 들일것으로 
예상되는 테이블
* 자주 갱신되는 테이블
*/
/*
인덱스 확인
*USER_INDEXES 데이터 사전 뷰는 인덱스의 이름과
그것의 유일성을 포함
*USER_IND_COLUMNS 뷰는 인덱스명, 테이블명, 열명을 
포함
*/
select ic.index_name,ic.column_name,
        ic.column_posittion col_pos, ic.uniquencess
        from user_indexes ix, user_ind_columns ic
        where ic.index_name = ix.index_name
        and ic.table_name = 'EMP';
 /*
  *데이터 사전에서 인덱스를 제거
  DROP INDEX index;
  *데이터 사전에서 EMP_ENAME_IDX 인덱스를 제거
  *인덱스를 제거하기위해, 
  인덱스의 DROP ANY INDEX 권한을
  갖고 있어야함
 */       
 /*
 동의어
 
 동의어(객체의 다른 이름)을 생성하여 
 객체에 대한 액세스를 단순화
 *다른 사용자가 소유한 테이블 참조
 *객체이름의 길이 단축
 CREATE [PUBLIC] SYNONYM synonym
 FOR object;
 */
 /*
 동의어 생성과 제거
 DEPT_SUM_VU 뷰에 대해 단축명을 생성
 */
 CREATE SYNONYM d_sum
 for dept_sum_vu;
 
 drop synonym d_sum;
 /*
 요약 
 *시퀀스를 사용하여 시퀀스 번호 자동 생성
 *USER_SEQUENCES 사전 테이블에서 시퀀스 정보 확인
 * 질의 검색 속도를 향상시키기 위해 인덱스 생성
 * USER_INDEXES 사전 테이블에서 인덱스 정보 확인
 *객체에 대한 대체 명을 제공하기 위해 동의어 사용
*/

/*
데이터 딕셔너리의 개념
+데이터베이스와 관련된 정보를 제공하기 위한
읽기 전용 테이블과 뷰의 집합, 약540개
+사용자는 데이터 딕셔너리 테이블과 뷰에 대해
select 명령문만 실행 가능

+데이터 딕셔너리에서 제공하는 정보
*데이터베이스의 물리적 구조 또는 객체의 논리적 구조
*오라클 사용자며과 스키마 객체명
*각 사용자에게 부여된 권한과 룰
*무결성 제약 조건에 대한 정보
*컬럼에 대한 기본 값
*스키마 객체에 할당된 영역의 크기와 
현재 사용중인 영역의 크기
*객체 접근 및 갱신에 대한 감사(Audit) 정보
*데이터베이스명, 버전, 생성날짜, 시작모드,
인스턴스명와 같은 일반적인 데이터베이스 정보
*/

/*
데이터 딕셔너리의 구조
    +기본 테이블
*데이터베이스 정보를 저장하는 기본 테이블
*테이블내의 데이터는 암호 형태로 저장
*AUD$를 제외하고는 기본 테이블은 오라클
서버만 쓰고 읽을 수 있으며 사용자는 직접
액세스 불가능
*기본 테이블명은 PROFILE$,DBJ$,COLTYPE$,
CON$,IND$ 등
* SQL,BSQ 스크립트를 사용하여 생성

+사용자가 액세스 가능한 데이터 딕셔너리 정보
*데이터 딕셔너리의 기본 테이블 정보를 요약한 뷰
*기본 테이블 정보를 단순화 하여 뷰의 형태로
사용자에게 제공
*오라클 서버는 사용자에게 뷰에 대한
읽기 전용 액세스만 허용
*뷰는 DBA_USERS, DBA_TABLES, V$DATABASE,
V$LOG, V$DATAFILE 등
*CATALOG.SQL 스크립트를 사용하여 생성

*/
/*
    +데이터 딕셔너리의 사용법
*DDL 명령문 실행시 오라클 서버에 의해
데이터딕셔너리 정보를 액세스
*사용자는 데이터베이스 정보에 대한 읽기
전용으로 데이터딕셔너리 정보 이요
*오라클 서버만이 데이터딕셔너리 정보를
기록 및 변경 가능 
*오라클 서버는 데이터베이스 작업동안
데이터딕셔너리 정보를 참조하여 객체 존재 여부와
사용자의 액세스 권한 확인
*오라클 서버는 데이터베이스 구조, 감사, 사용자 권한,
데이터 등의 변경 사항을 반영하기 위해 
데이터 딕셔너리를 계속적으로 갱신

    +데이터 딕셔너리의 주요용도 
*데이터딕셔너리 정보에 대한 빠른 엑세스
-오라클 서버는 데이터베이스 작업동안 계속적으로
사용자 액세스 권한 검증 및 객체 상태 확인 작업을
하므로 대부분의 데이터딕셔너리 정보는 시스템
글로벌 영역에 저장 가능

*새로운 데이터딕셔너리 항목 추가
-데이터딕셔너리에 테이블 또는 뷰 추가가능
-데이터딕셔너리에 객체 추가시, 객체 소유자는 
시스템 사용자나 제3의 오라클 사용자임

*데이터딕셔너리 항목 삭제 또는 변경
-데이터딕셔너리의 데이터는 사용자가 삭제 또는 
변경 불가능하며 오라클 서버만 가능

*공용 동의어
-데이터 딕셔너리에 생성된 동의어를 
사용자가 액세스

+오라클 사용자의 데이터 딕셔너리 사용

*데이터직셔너리 뷰는 모든 데이터베이스 사용자가 액세스 가능

*SQL 명령문에 의해 데이터 딕셔너리뷰에 대한 
액세스 가능

*데이터딕셔너리 뷰는 데이터베이스가 열려 있는 동안
항상 사용가능

*데이터딕셔너리 정보는 시스템 테이블스페이스에 저장

*사용자는 뷰 형태의 데이터 딕셔너리만
액세스가능

+user, all, dba의 접두어를 가짐



*/

