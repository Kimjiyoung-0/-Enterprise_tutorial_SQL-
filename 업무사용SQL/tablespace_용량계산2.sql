select 
    tablespace_name,
    maxsize as "allocatable_file_maxsize(M)",
    file_size as "real_allocated_file_size(M)",
    seg_size as "real_allocated_seg_size(M)",
    round((maxsize - seg_size)/maxsize*100) as"free_percent(%)"
from ( 
    select 
        a.tablespace_name, 
        round(sum(decode(a.maxbytes,0,a.bytes,a.maxbytes))/1024/1024) as maxsize,
        round(sum(a.bytes)/1024/1024) as file_size,
        round((sum(a.bytes) - sum(b.bytes))/1024/1024) as seg_size
    from dba_data_files a ,dba_free_space b
    where a.TABLESPACE_NAME =b.TABLESPACE_NAME 
    group by a.tablespace_name --테이블 스페이스별로 정리
) 
order by "free_percent(%)"
;

/* 
tablespace_name, 
-- table space 의 name

allocatable_file_maxsize(M), 
-- dba_data_files 에서 데이터 파일들의 정보 중 
어느 데이터 파일이 테이블스페이스에 할당되어있는지(여러개에 붙어있을수 있으니)
MAXBYTES를 더하되, 이미 다차버린 데이터 파일을 체크할것
(MAXBYTES 가 0 이면 사용중인 값 BYTES를 가져온다.)

real_allocated_file_size(M), 
-- dba_data_files 에서 나타나는 정보들중 BYTES(사용중인 데이터량)를 총합한 값 

real_allocated_seg_size(M),  --
--dba_data_files 에서 나타난 정보는 사용된 데이터 블럭을 기준으로 체크한다.
그래서 블럭자체에 비어있는 값을 체크해야하는데, 두가지 방식이 있다. 
real_allocated_file_size(M)-(dba_free_space 에서 BYTES를 전부 더한 값)


free_percent(%) -- 정말로 비어있는 값까지 계산된 %



*/

