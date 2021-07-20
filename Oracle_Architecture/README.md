# 오라클 아키택쳐<br>
오라클 프로그램이 내부에서 어떻게 동작하는지 <br>
오라클 아키택쳐를 배움으로서 이해하게됨<br>
오라클 프로그램이 돌아가는 환경은 크게 3가지로 분류됨<br>

프로세스, 메모리 ,파일 로 구분됨<br>
![image](https://user-images.githubusercontent.com/71188378/126093081-a4cd664e-29ad-483c-bad8-5201b0c45045.png)

## 프로세스<br>
프로세스는 말그대로 오라클의 프로세스들을 뜻함<br>
프로세스도 크게 분류하면 3가지 부분으로 분류되는데,<br>
유저 , 서버, 백그라운드로 분류됨 <br>

### 유저
유저는 말그대로 유저 클라이언트를 뜻하여 <br>
유저가 다루는 부분이라 아키택쳐에선 그냥 있다고만 묘사됨<br>
(개개인이 다른 환경을 구축하는 상황에서 오라클은 오는 데이터만 잘 리턴해주면 된다.)<br>

### 서버
서버는 이제 유저가 보낸 데이터들을 처리하는 실질적인 단계로<br> 
유저가 SQL문을 보내면 메모리에 엑세스하여 처리하는 프로세스이다.<br>
서버 프로세스에는 PGA라는 메모리영역이 있는데 이것은 후술한다.<br>

### 백그라운드 프로세스
백그라운드 프로세스는 오라클 인스턴스내부에 존재하는 <br>
사용자에게 노출되지않는 프로세스들을 뜻함 <br>
PMON, SMON, CKPT, DBWR, LGWR, ARCH 등이 있음<br>

#### PMON
PMON은 프로세스들을 관리하는 역할이다.<br>
프로세스들을 모니터링 하다가 프로세스의 비정상적인 종료가<br>
감지되면 그 프로세스를 재가동, 또는 종료 시키고,<br>
그 프로세스로 인한 lock(Database으 무결성을 위한 Database 제한 방법)을 해제 한다.<br>

#### SMON
SMON은 복구 담당으로 <br>
오라클의 데이터베이스가 일치하지 않을때<br>
그것을 복구 시키는 역할<br>

#### CKPT
CKPT 체크포인트 이벤트를 발생<br>
체크포인트는 오라클의 빠른커밋 매커니즘과 연관이있다.<br>
오라클은 빠른커밋 매커니즘으로 DML명령이 들어오고 커밋되면(데이터가 수정되면)<br>
일단 로그만 Redo log file에 반영한다. 그리고 Data는 나중에 반영하게 되는데, <br>
일정시간이 지나거나, 메모리의 공간이 부족하여 Datafile에 변경된 데이터를 반영하는게<br>
바로 체크포인트 이벤트이다. <br>
이때 체크포인트 이벤트를 발생 시킬때 <br>
SCN 를 제대로 체크하여 LOG파일과 DATA파일의 싱크를 맞춰준다.<br>

#### DBWR
DBWR는 datafile에 data를 작성한다.<br>
실질적으로 테이블을 수정, 조작하는 역할이다.<br>

#### LGWR
LGWR는 Redolog file에 로그를 기록한다 <br>
테이블에 데이터는 반영이 안되도 로그가 남아있으면,<br>
로그를 복기하여 데이터를 복구 해낼수 있다.<br>
(로그에는 그동안 입력되있던 SQL문의 기록이 있기 때문에 <br>
SQL문의 기록을 복기하면 결국 최종적으로 데이터를 복구해 낼수 있다.)<br>

## 메모리
메모리는 크게 PGA ,SGA로 나뉜다.<br>

### PGA
PGA는 서버 프로세스에 속해 각 유저별로 따로 생성되는 영역이다.<br>
PGA는 유저 한명의 SORT,JOIN 데이터를 담고있다.<br>
(SORT,JOIN 데이터는 각각 다르게 쓰기때문)<br>

### SGA
SGA는 오라클 인스턴스에 있는 영역으로 <br>
이 영역은 모든 유저들이 공유해서 쓰는 공간이다.<br>
SGA는 Shared pool, Buffer Cache, Redo log Buffer Cache로 나뉜다.<br>
#### Shared pool
Shared pool은 또 Library Cache, Dictionary Cache로 나뉜다.<br>
##### Library Cache
Library Cache는 SQL의 과정 Plan을 저장한다.<br>
plan을 저장했다가 유저가 SQL을 입력하고,<br>
SQL의 오류가 없다고 판단되면 <br>
라이브러리 캐쉬의 plan을 뒤져본다.<br>
이때 plan에 똑같은 SQL문의 과정이 있으면<br>
그 Plan을 사용해 메모리를 아낀다.<br>
(이과정을 소프트 파싱이라 한다.)<br>

##### Dictionary Cache
Dictionary Cache는 유저한테 노출되지 않는<br>
테이블의 아이디 , 유저들의 권한 등을 가지고 있다.<br>
유저가 SQL문을 입력하면 딕셔너리 캐시에 있는 ,<br>
테이블 아이디, 유저 권한등을 프로세스가 참고해<br>
이 유저가 SQL문을 사용할 수 있는 지 확인한다.<br>
(유저의 권한이 적합하지 않으면 캔슬)<br>

#### Buffer Cache
Buffer Cache는 Datafile에 저장되있는 실질적인 테이블 데이터들을<br>
보관해 사용하는 메모리 영역이다. 이 영역의 최소단위는 <br>
Data block으로 유저가 SQL문을 입력하고 소프트 파싱이 안될때<br>
서버프로세스가 이 영역에 Data들을 올려 처리한다. <br>
이 영역은 세가지 상태가 있는데 Dirty, Pined, Clean 이다.<br>
Clean은 비어있는 데이터 블록을, <br>
Pined는 사용중인 데이터 블록을, <br>
Dirty는 사용하고 데이터가 남아있는 블록을 의미한다.<br>
만약 메모리 영역이 모자르거나, 일정시간이 지나면 <br>
DBWR가 데이터들을 Datafile에 반영하여 <br>
Dirty 블록들을 Clean으로 처리한다. <br>

#### Redo Log Buffer Cache
log buffer cache에는 로그들이 저장되어 <br>
Lgwr에 의해 로그 파일에 기록된다.<br>
오라클의 빠른커밋 매커니즘으로 인해<br>
SQL문이 입력되면 로그는 바로 로그파일에 쓰여진다.<br>
(정확히는 SQL문이 입력되고, Redo Log Buffer 캐시의 상황에따라 
허나, commit이 안되도 일단 기록됨.)<br>
사용자가 커밋을 하면 그때 로그 파일들이 보증된다.<br>

## 파일 
파일은 또 세가지로 구성된다. 
Control, Data, Log

### Control
Control 파일은 데이터베이스에 필요한 정보들을 저장하는 파일이다.
데이터베이스의 이름, 식별자, 생성일,<br>
데이터베이스와 로그 파일들의 위치,<br>
테이블 스페이스 이름<br>
Log history 및 backup 정보 등<br>
오라클이 켜질때 parameter파일에 존재하는 <br>
컨트롤 파일에 대한 정보로 컨트롤파일을 불러와 마운트 한다.<br>

### Data 
말그대로 Datafile 이다.<br>
실질적인 테이블 정보가 저장된다.<br>
SYSTEM FILE

### Log 
Logfile이 저장된다.<br>
Logfile은 최소 두개 이상의 그룹으로 운영되는데,<br>
하나의 그룹이 로그로 꽉차면 다른 로그그룹으로 넘어간다.<br>
또, 그룹은 한개이상의 멤버로 구성되는데, 이때 같은 그룹의 멤버는 <br>
똑같은 데이터를 저장한다. <br>
예를 들어 A그룹의 1,2 번 멤버 , B그룹의 1,2번 멤버가 있다고 가정하자<br>
이때 A그룹의 1번 멤버와 B그룹의 2번 멤버가 손상되어도 <br>
A그룹의 2번멤버, B그룹의 1번 멤버의 정보로 데이터 베이스를 온전하게<br>
유지할 수 있다.<br>

![image](https://user-images.githubusercontent.com/71188378/126094172-3255413b-0983-4664-a83f-1d6d4bbe4e88.png)
## SQL문의 실행과정<br>
### select문 실행과정(그림 참조)

클라이언트에서 SQL문 전송<br>
서버 프로세스에서 받는다

shared pool에 library cache에서
plan을 찾는다.
(만약 조인,order by시 PGA에 저장) 

plan을 찾는데, 있으면 그 plan을 따라가고(소프트 파싱),

없으면 새로운 plan 생성(하드 파싱)
Data Dictonary Cache에서 테이블등의 정보를 확인해 권한확인

그 다음  하드파싱을 했을시 
DB(Data file)에서 테이블, 인덱스 정보를 읽어와서 
Buffer cache에 올린다.
그런뒤 결과를 종합하여
유저 에게 리턴

### DML(insert, delete, update) 실행 과정
클라이언트에서 SQL문 전송
서버 프로세스에서 받는다.

shared pool에 library cache에서
plan을 찾는다.
(만약 조인,order by시 PGA에 저장) 
plan을 찾는데, 있으면 그 plan을 따라가고(소프트 파싱),
없으면 새로운 plan 생성(하드 파싱)
Data Dictonary Cache에서 테이블등의 정보를 확인해 권한확인

plan이 생성되면 
Datafiles에서 DB wirter가 Datafile를 읽어옴
그 다음 Buffer Cache에 올라온 데이타에 
변경된 데이타를 반영
이때 Before은 rollback segment에 
after는 Buffer Cache의 데이터 블럭에
Before after 둘다는 Redo log file에 저장된다.
또한, 사용자가 커밋을 안해도 
오라클은 커밋을 가정하고, 돌아가는 알고리즘으로인해(빠른 커밋) 
일정시간 마다, 또는 Redo log Buffer Cache가 33퍼가 채워졌을 때 등
Redo log file이 Log Writer에 의해 
Log file에 저장됨.

Buffer Cache에 있는 데이터는 그 크기가 커
알고리즘에 따라 
일정시간 마다, 또는 Buffer Cache에 공간이 필요한데 데이터블록이
Dirty(log는 기록됬지만 Buffer에 남아있는 Data)일때
DBWriter에 의해 Data files에 기록됨

만약 이때 서버가 다운되어 
데이터가 날아갔을시,
Check point를 기준으로 Redo log files를 읽어서 복구

log file에 반영되면 그때 유저한테 결과 리턴

### DDL(drop, create, Alter) 실행 과정
클라이언트에서 SQL문 전송
서버 프로세스에서 받는다.

DDL은 무조건 하드 파싱으로 진행된다.
(만약 조인,order by시 PGA에 저장)
Data Dictionary Cache에서 테이블등의 정보를 확인해 권한확인

plan이 생성되면 
Datafiles에서 DB wirter가 Datafile를 읽어옴
그 다음 Buffer Cache에 올라온 데이타에 
변경된 데이타를 반영
이때 Before은 rollback segment에 
after는 Buffer Cache의 데이터 블럭에
Before after 둘다는 Redo log file에 저장된다.
또한, 사용자가 커밋을 안해도 
오라클은 커밋을 가정하고, 돌아가는 알고리즘으로인해(빠른 커밋) 
일정시간 마다, 또는 Redo log Buffer Cache가 33퍼가 채워졌을 때 등
Redo log file이 Log Writer에 의해 
Log file에 저장됨.

Buffer Cache에 있는 데이터는 그 크기가 커
알고리즘에 따라 
일정시간 마다, 또는 Buffer Cache에 공간이 필요한데 데이터블록이
Dirty(log는 기록됬지만 Buffer에 남아있는 Data)일때
DBWriter에 의해 Data files에 기록됨

만약 이때 서버가 다운되어 
데이터가 날아갔을시,
Check point를 기준으로 Redo log files를 읽어서 복구

log file에 반영되면 그때 유저한테 결과 리턴
또한 DDL은 실행되면, 묵시적인 commit이 일어난다.(무조건)

DDL이 커밋되면 Dictionary Cache의 테이블 정보,
Data file등이 DDL에 맞춰서 알고리즘(옵티마이저가)알아서 갱신한다.

log에 기록되면 결과를 유저한테 리턴한다.
